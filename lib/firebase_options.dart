// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEe6-IHbDhWBBEKiMOCQkEU2DmsZ4Hwy4',
    appId: '1:370748406251:android:9e4c26de789d35c83441ae',
    messagingSenderId: '370748406251',
    projectId: 'skripsi-ba-parkir-99',
    storageBucket: 'skripsi-ba-parkir-99.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDO8cBplA4yncoALPfPbtApl1NB3upLh48',
    appId: '1:370748406251:web:bb1a12ffae11604d3441ae',
    messagingSenderId: '370748406251',
    projectId: 'skripsi-ba-parkir-99',
    authDomain: 'skripsi-ba-parkir-99.firebaseapp.com',
    storageBucket: 'skripsi-ba-parkir-99.appspot.com',
    measurementId: 'G-K7SN13G7ZE',
  );

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyDO8cBplA4yncoALPfPbtApl1NB3upLh48",
      authDomain: "skripsi-ba-parkir-99.firebaseapp.com",
      databaseURL:
          "https://skripsi-ba-parkir-99-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "skripsi-ba-parkir-99",
      storageBucket: "skripsi-ba-parkir-99.appspot.com",
      messagingSenderId: "370748406251",
      appId: "1:370748406251:web:bb1a12ffae11604d3441ae",
      measurementId: "G-K7SN13G7ZE");
}
