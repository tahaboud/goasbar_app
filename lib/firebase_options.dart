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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB7WqF8Ec0871gynwuVpdibYLeiCpCm9UI',
    appId: '1:59603340838:android:e840927f8209419071e0e7',
    messagingSenderId: '59603340838',
    projectId: 'asbar-49052',
    databaseURL: 'https://asbar-49052-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'asbar-49052.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCi7b3McMQOD0XbOf7yXrdS2gFMSOs-vwo',
    appId: '1:59603340838:ios:dcfaa447915898f171e0e7',
    messagingSenderId: '59603340838',
    projectId: 'asbar-49052',
    databaseURL: 'https://asbar-49052-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'asbar-49052.appspot.com',
    iosClientId: '59603340838-kpf3hb640jt3dg1qlftg5s64ctqgqb0t.apps.googleusercontent.com',
    iosBundleId: 'com.goasbar.goAsbar',
  );
}