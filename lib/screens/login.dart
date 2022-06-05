import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoflutterfirebase/providers/login_provider.dart';
import 'package:todoflutterfirebase/screens/createAccount.dart';
import 'package:todoflutterfirebase/screens/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State createState() => LoginState();
}

class LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  GoogleSignInAccount? _currentUser;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  String errorUI = "";

  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _googleSignIn.signOut();
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        setState(() {
          _currentUser = account;
          _setUsername(_currentUser!.id, "google");
          _isLogin = true;
        });
        if (_currentUser != null) {}
      });
      _googleSignIn.signInSilently();
    }
  }

  Future _handleGoogleSignIn() async {
    try {
      _googleSignIn.signIn();
    } catch (error) {
      setState(() {
        errorUI = "Error Signin with Google Try Again";
      });
    }
  }

  Future<void> _handleSignWithEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (mounted) {
        setState(() {
          _setUsername(userCredential.user!.uid, "email");
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          errorUI = 'Wrong Email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorUI = 'Wrong Password';
        });
      } else {
        setState(() {
          errorUI = 'Wrong User';
        });
      }
    }
  }

  Future<void> _setUsername(String user, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", user);
    prefs.setString("loginFrom", value);
    prefs.setBool("username", true);
    await _delaySplash(user);
  }

  Future<void> _delaySplash(String userId) async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home(userId)),
          ModalRoute.withName("/Home"));
    });
  }

  @override
  Widget build(BuildContext context) {
    print("login");

    if (_isLogin == true) {
      return const Scaffold(
        body: Center(
          child: Text('You are Signed in successfully'),
        ),
      );
    }

    if (_isLogin== true) {
      return const Scaffold(
        body: Center(
          child: Text('You are Signed in successfully'),
        ),
      );
    } else {
      return ChangeNotifierProvider(
          create: (context) => LoginData(),
          builder: (BuildContext context, child) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Consumer<LoginData>(builder: (context, value, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.blueGrey,
                          size: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Email",
                            errorText:
                                value.validateEmail ? "can't be empty" : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "password",
                            errorText: value.validatePassword
                                ? "can't be empty"
                                : null,
                          ),
                        ),
                      ),
                      Text(errorUI, style: const TextStyle(color: Colors.red)),
                      TextButton(
                        style: TextButton.styleFrom(
                          elevation: 2.0,
                          fixedSize: const Size(220, 15),
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          _emailController.text.isEmpty
                              ? Provider.of<LoginData>(context, listen: false)
                                  .changeValidateEmail(true)
                              : Provider.of<LoginData>(context, listen: false)
                                  .changeValidateEmail(false);
                          _passwordController.text.isEmpty
                              ? Provider.of<LoginData>(context, listen: false)
                                  .changeValidatePassword(true)
                              : Provider.of<LoginData>(context, listen: false)
                                  .changeValidatePassword(false);
                          if (value.validateEmail == false &&
                              value.validatePassword == false) {
                            //save data firebase
                            _handleSignWithEmail();
                          }
                        },
                        child: const Text("Login with Email"),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            elevation: 2.0,
                            fixedSize: const Size(220, 15),
                            primary: Colors.white,
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: () async {
                            //save data firebase
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccount()));
                          },
                          child: const Text("Create Account with Email"),
                        ),
                      ),
                      SignInButton(
                        Buttons.Google,
                        text: "Continue with Google",
                        onPressed: _handleGoogleSignIn,
                      ),
                    ],
                  );
                }),
              ),
            );
          });
    }
  }
}
