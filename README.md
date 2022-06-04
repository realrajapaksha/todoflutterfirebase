# todoapp with flutter and Firebase Firestore

Simple Flutter todo App with Cloud Firebase Firestore Database, Firebase Auth and Google Sign.

## Versions and Dependencies
[Flutter 3.0.0 • channel stable](https://flutter.dev/)  
[Dart 2.17.0  ](https://dart.dev/)  

[firebase_core: ^1.17.0](https://pub.dev/packages/firebase_core)  
[firebase_auth: ^3.3.18](https://pub.dev/packages/firebase_auth)  
[cloud_firestore: ^3.1.15](https://pub.dev/packages/cloud_firestore)  
[google_sign_in: ^5.3.1](https://pub.dev/packages/google_sign_in)  
[shared_preferences: ^2.0.15](https://pub.dev/packages/shared_preferences)  
[flutter_signin_button: ^2.0.0](https://pub.dev/packages/flutter_signin_button)  

## Install Firebase cmd
1. npm install -g firebase-tools
2. firebase login
3. dart pub global activate flutterfire_cli
4. Set flutterfire_cli path
5. flutterfire configure

## Setup Firebase Auth / Google Signin
1. flutter pub add google_sign_in: ^5.3.1.
2. android -> edit gradle.properties -> copy existing value of org.gradle.jvmargs and replace it -XX:MaxHeapSize=256m -Xmx256m.
3. android -> open cmd -> gradlew signingReport.
4. copy SHA1 Value in Task :app:signingReport.
5. Go to firebase project -> Authentication -> Sign-in Methods -> Enable Google.
6. Go to firebase project -> Project settings -> General -> Your apps >  select your android app -> add fingerprints -> paste your SHA1 value and save.
- android -> edit gradle.properties -> paste existing value of org.gradle.jvmargs  

## Errors and Fixers

[stackoverflow Answer for signinReport](https://stackoverflow.com/a/60804020)  
[Multidex Support](https://developer.android.com/studio/build/multidex)  
[iOS Error running pod install](https://github.com/flutter/flutter/issues/104118)  

## References

[Flutter Documentation](https://docs.flutter.dev/)  
[Add Firebase to your Flutter app documentation](https://firebase.google.com/docs/flutter/setup?platform=android)  
[Firebase Firestore Documentation](https://firebase.google.com/docs/firestore/quickstart#dart)  
[Firebase Auth](https://firebase.flutter.dev/docs/auth/usage)  
