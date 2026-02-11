import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return windows;
  }

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCEzpiUQIrC7cB7hXfMqmbmAlmW8LRQgsc',
    authDomain: 'pharmacy-app-pro.firebaseapp.com',
    projectId: 'pharmacy-app-pro',
    storageBucket: 'pharmacy-app-pro.firebasestorage.app',
    messagingSenderId: '500232057984',
    appId: '1:500232057984:web:467b423e25f27ff5cc2265',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY_HERE',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY_HERE',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.pharmacyApp',
  );
}
