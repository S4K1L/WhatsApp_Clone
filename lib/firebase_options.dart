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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAljbm935d0qckpiEgQzz3yqt57UcQqsNc',
    appId: '1:540536897229:web:ef7720a367625f504a7384',
    messagingSenderId: '540536897229',
    projectId: 'whatsapp-clone-app-afb45',
    authDomain: 'whatsapp-clone-app-afb45.firebaseapp.com',
    storageBucket: 'whatsapp-clone-app-afb45.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3ASD16g5LTuO5TtOMl1TzrAx5YnsdCNw',
    appId: '1:540536897229:android:3541227a6bcdc04b4a7384',
    messagingSenderId: '540536897229',
    projectId: 'whatsapp-clone-app-afb45',
    storageBucket: 'whatsapp-clone-app-afb45.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBX1OG-97UiXzsq8r_AHNWxSO_AKyZhY04',
    appId: '1:540536897229:ios:ee91d3d7768c5d7c4a7384',
    messagingSenderId: '540536897229',
    projectId: 'whatsapp-clone-app-afb45',
    storageBucket: 'whatsapp-clone-app-afb45.appspot.com',
    iosBundleId: 'com.example.whatsappCloneApp',
  );
}
