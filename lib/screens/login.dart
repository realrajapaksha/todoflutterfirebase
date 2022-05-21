import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoflutterfirebase/screens/home.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State createState() => LoginState();
}

class LoginState extends State<Login> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.signOut();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {}
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  _setUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
  }

  _delaySplash() async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          ModalRoute.withName("/Home"));
    });
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount? user = _currentUser;

    if (user != null) {
      _setUsername(user.id);
      _delaySplash();
      return const Scaffold(
        body: Center(
          child: Text('You are Signed in successfully'),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                color: Colors.blueGrey,
                size: 60,
              ),
              const SizedBox(
                height: 15,
              ),
              SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: _handleSignIn,
              ),
            ],
          ),
        ),
      );
    }
  }
}
