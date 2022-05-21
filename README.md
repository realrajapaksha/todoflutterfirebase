# todoapp with flutter and Firebase Firestore

Simple Flutter todo App with Cloud Firebase Firestore Database

## Versions
- [Flutter](https://flutter.dev/) 3.0.0 • channel stable
- [Dart](https://dart.dev/) 2.17.0
- firebase_core: ^1.17.0
- firebase_auth: ^3.3.18
- cloud_firestore: ^3.1.15
- google_sign_in: ^5.3.1
- shared_preferences: ^2.0.15
- flutter_signin_button: ^2.0.0

## Install Firebase cmd
- npm install -g firebase-tools
- firebase login
- dart pub global activate flutterfire_cli
- Set flutterfire_cli path
- flutterfire configure
- flutter pub add firebase_core

[Add Firebase to your Flutter app documentation](https://firebase.google.com/docs/flutter/setup?platform=android)  
[Dart Flutter Programming](https://firebase.google.com/docs/firestore/quickstart#dart_4)

## Setup Google Signin
- flutter pub add google_sign_in: ^5.3.1.
- android -> edit gradle.properties -> copy existing value of org.gradle.jvmargs and replace it -XX:MaxHeapSize=256m -Xmx256m.
- android -> open cmd -> gradlew signingReport.
- copy SHA1 Value in Task :app:signingReport.
- Go to firebase project -> Authentication -> Sign-in Methods -> Enable Google.
- Go to firebase project -> Project settings -> General -> Your apps >  select your android app -> add fingerprints -> paste your SHA1 value and save.
- android -> edit gradle.properties -> paste existing value of org.gradle.jvmargs


[stackoverflow Answer for signinReport](https://stackoverflow.com/a/60804020)  
[Multidex Support](https://developer.android.com/studio/build/multidex)

## References
For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials, and Flutter with Firebase development, view the
[firebase firestore documentation](https://firebase.google.com/docs/firestore/quickstart#dart)
