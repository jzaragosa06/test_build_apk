// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAt8FJ-v6NkQyo1jsBTT4kPsIgi-WViuXA',
    appId: '1:184891681961:web:24a02eaeaf557743634db8',
    messagingSenderId: '184891681961',
    projectId: 'midtermpractice2-238be',
    authDomain: 'midtermpractice2-238be.firebaseapp.com',
    storageBucket: 'midtermpractice2-238be.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5yQSWr7hFFSm1Qx2esvPxcAw4ICHd0gM',
    appId: '1:184891681961:android:eb466469039857c9634db8',
    messagingSenderId: '184891681961',
    projectId: 'midtermpractice2-238be',
    storageBucket: 'midtermpractice2-238be.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArvAyLrxyn-_E7AoWQQMOsK1I0tcz0ilI',
    appId: '1:184891681961:ios:e93ca180e9fa2b2b634db8',
    messagingSenderId: '184891681961',
    projectId: 'midtermpractice2-238be',
    storageBucket: 'midtermpractice2-238be.appspot.com',
    iosBundleId: 'com.example.testBuildApk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArvAyLrxyn-_E7AoWQQMOsK1I0tcz0ilI',
    appId: '1:184891681961:ios:e93ca180e9fa2b2b634db8',
    messagingSenderId: '184891681961',
    projectId: 'midtermpractice2-238be',
    storageBucket: 'midtermpractice2-238be.appspot.com',
    iosBundleId: 'com.example.testBuildApk',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAt8FJ-v6NkQyo1jsBTT4kPsIgi-WViuXA',
    appId: '1:184891681961:web:9e5219cfbc3e076e634db8',
    messagingSenderId: '184891681961',
    projectId: 'midtermpractice2-238be',
    authDomain: 'midtermpractice2-238be.firebaseapp.com',
    storageBucket: 'midtermpractice2-238be.appspot.com',
  );
}
