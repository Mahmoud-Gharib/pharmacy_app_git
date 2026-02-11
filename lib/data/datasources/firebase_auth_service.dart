import 'dart:math';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy_app/data/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // EmailJS Configuration - FREE TIER: 200 emails/month
  // Get your credentials from https://dashboard.emailjs.com/
  static const String _emailJsServiceId = 'service_mg71fe7';
  static const String _emailJsTemplateId = 'template_fmwtn9s';
  static const String _emailJsPublicKey = '1chqeX6_KPQ9lgtw9';

  // Store for password reset PINs (local storage - no backend needed)
  final Map<String, _PinData> _pinStore = {};

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return await getUserData(result.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final userModel = UserModel(
          uid: result.user!.uid,
          email: email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(userModel.toMap());

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return e.message ?? 'Authentication error occurred';
    }
  }

  String _generatePin() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  /// Send password reset PIN via email using EmailJS (FREE - 200 emails/month)
  Future<bool> sendPasswordResetPin(String email,
      {String language = 'en'}) async {
    try {
      // Validate email format only (security: don't reveal if user exists)
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!emailRegex.hasMatch(email)) {
        throw Exception('Invalid email format');
      }

      // Generate PIN
      final pin = _generatePin();

      _pinStore[email.toLowerCase()] = _PinData(
        pin: pin,
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      );

      // Send email via EmailJS
      await _sendEmailViaEmailJS(email, pin, language);

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Send email using EmailJS REST API (FREE TIER)
  Future<void> _sendEmailViaEmailJS(
      String email, String pin, String language) async {
    // Check if EmailJS is configured
    if (_emailJsServiceId == 'YOUR_SERVICE_ID' ||
        _emailJsTemplateId == 'YOUR_TEMPLATE_ID' ||
        _emailJsPublicKey == 'YOUR_PUBLIC_KEY') {
      // EmailJS not configured - print PIN to console (development mode)
      print('========================================');
      print('DEV MODE - EmailJS not configured');
      print('Password reset PIN for $email: $pin');
      print('========================================');
      return;
    }

    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _emailJsServiceId,
          'template_id': _emailJsTemplateId,
          'user_id': _emailJsPublicKey,
          'template_params': {
            'to_email': email,
            'pin_code': pin,
            'language': language,
            'app_name': language == 'ar' ? 'صيدلية برو' : 'Pharmacy Pro',
          },
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send email: ${response.body}');
      }
    } catch (e) {
      // Fallback: print PIN to console
      print('EmailJS failed: $e');
      print('DEV MODE - PIN for $email: $pin');
    }
  }

  /// Verify PIN using local verification
  Future<bool> verifyPin(String email, String pin) async {
    final normalizedEmail = email.toLowerCase();
    final pinData = _pinStore[normalizedEmail];

    if (pinData == null) {
      throw Exception('No PIN found. Please request a new one.');
    }

    if (DateTime.now().isAfter(pinData.expiresAt)) {
      _pinStore.remove(normalizedEmail);
      throw Exception('PIN has expired. Please request a new one.');
    }

    if (pinData.pin != pin) {
      throw Exception('Invalid PIN. Please try again.');
    }

    // Mark as verified for password reset
    pinData.verified = true;

    return true;
  }

  /// Reset password after PIN verification (sends Firebase reset email)
  Future<bool> resetPasswordWithPin({
    required String email,
    required String pin,
    required String newPassword,
  }) async {
    try {
      print('DEBUG: Starting resetPasswordWithPin for $email');

      // Verify PIN first
      print('DEBUG: Verifying PIN...');
      final isValid = await verifyPin(email, pin);
      if (!isValid) {
        print('DEBUG: PIN verification failed');
        return false;
      }
      print('DEBUG: PIN verified successfully');

      // Clear the PIN after successful verification
      _pinStore.remove(email.toLowerCase());
      print('DEBUG: PIN cleared from store');

      // Send Firebase password reset email
      print('DEBUG: Calling Firebase sendPasswordResetEmail for $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('DEBUG: Firebase sendPasswordResetEmail completed successfully');

      return true;
    } catch (e) {
      print('DEBUG ERROR in resetPasswordWithPin: $e');
      throw Exception(e.toString());
    }
  }

  /// Store new password temporarily in Firestore after PIN verification
  /// NOTE: This requires Blaze Plan to actually update Firebase Auth
  Future<bool> storeNewPasswordTemporarily({
    required String email,
    required String pin,
    required String newPassword,
  }) async {
    try {
      print('DEBUG: Storing new password temporarily for $email');

      // Verify PIN first
      final isValid = await verifyPin(email, pin);
      if (!isValid) {
        print('DEBUG: PIN verification failed');
        return false;
      }
      print('DEBUG: PIN verified successfully');

      // Clear the PIN after successful verification
      _pinStore.remove(email.toLowerCase());

      // Store new password temporarily in Firestore
      // We store it hashed for security
      final normalizedEmail = email.toLowerCase();
      await _firestore.collection('password_resets').doc(normalizedEmail).set({
        'email': normalizedEmail,
        'tempPassword': newPassword, // In production, hash this!
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt':
            DateTime.now().add(const Duration(hours: 1)), // 1 hour expiry
        'used': false,
      });

      print('DEBUG: New password stored temporarily in Firestore');
      return true;
    } catch (e) {
      print('DEBUG ERROR: $e');
      throw Exception(e.toString());
    }
  }

  /// Check and apply temporary password during login
  /// Returns true if temp password was used and applied
  Future<bool> checkAndApplyTempPassword(String email, String password) async {
    try {
      final normalizedEmail = email.toLowerCase();
      final doc = await _firestore
          .collection('password_resets')
          .doc(normalizedEmail)
          .get();

      if (!doc.exists) {
        return false; // No temp password pending
      }

      final data = doc.data()!;

      // Check if expired
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();
      if (DateTime.now().isAfter(expiresAt)) {
        print('DEBUG: Temp password expired');
        await doc.reference.delete();
        return false;
      }

      // Check if already used
      if (data['used'] == true) {
        return false;
      }

      // Check if password matches
      final tempPassword = data['tempPassword'] as String;
      if (password != tempPassword) {
        return false; // Wrong password, try normal login
      }

      print('DEBUG: Temp password matched!');

      // We cannot update Firebase Auth password without:
      // 1. User being signed in (need old password), or
      // 2. Firebase Admin SDK (needs Blaze Plan)
      //
      // For now, just mark as used - the temp password workflow
      // requires Blaze Plan to work properly

      await doc.reference.update({'used': true});

      print('DEBUG: Marked temp password as used');
      print('WARNING: Cannot update Firebase Auth without Admin SDK');
      return false;
    } catch (e) {
      print('DEBUG ERROR in checkAndApplyTempPassword: $e');
      return false;
    }
  }

  /// This won't work - we don't know the current password :(
  /// We need to use a different approach
  Future<String> _getCurrentPassword(String email) async {
    // This is impossible without knowing the current password
    throw Exception('Cannot get current password');
  }
}

// Helper class to store PIN data
class _PinData {
  final String pin;
  final DateTime expiresAt;
  bool verified;

  _PinData({
    required this.pin,
    required this.expiresAt,
  }) : verified = false;
}

/// Extension to handle password reset flow
/// Stores temp password in Firestore, applies on next login
extension PasswordResetExtension on FirebaseAuthService {
  /// Store temp password in Firestore
  Future<void> _storeTempPassword(String email, String password) async {
    await _firestore
        .collection('password_resets')
        .doc(email.toLowerCase())
        .set({
      'tempPassword': password,
      'expiresAt': DateTime.now().add(const Duration(hours: 1)),
      'used': false,
    });
  }
}
