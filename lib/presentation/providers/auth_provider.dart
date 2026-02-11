import 'package:flutter/material.dart';
import 'package:pharmacy_app/data/datasources/firebase_auth_service.dart';
import 'package:pharmacy_app/data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        _isAuthenticated = true;
        _loadUserData(user.uid);
      } else {
        _isAuthenticated = false;
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final userData = await _authService.getUserData(uid);
      _currentUser = userData;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
    return false;
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _currentUser = null;
    _isAuthenticated = false;
    _setLoading(false);
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Send password reset PIN to email
  Future<bool> sendPasswordResetPin(String email,
      {String language = 'en'}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.sendPasswordResetPin(email, language: language);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Verify the PIN code
  Future<bool> verifyPin(String email, String pin) async {
    _setLoading(true);
    _clearError();

    try {
      final isValid = await _authService.verifyPin(email, pin);
      _setLoading(false);
      return isValid;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Reset password with verified PIN
  Future<bool> resetPasswordWithPin({
    required String email,
    required String pin,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.resetPasswordWithPin(
        email: email,
        pin: pin,
        newPassword: newPassword,
      );
      _setLoading(false);
      return success;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
