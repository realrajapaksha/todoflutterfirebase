import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todoflutterfirebase/providers/login_provider.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  String errorUI = "";

  bool isCreated = false;

  Future<void> _handleCreateWithEmail() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      setState(() {
        isCreated = true;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorUI = 'The password provided is too weak';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          errorUI = 'The account already exists for that email.';
        });
      }
    } catch (e) {
      setState(() {
        errorUI = 'Error Create Account Try Again';
      });
    }
  }

  Future<void> _delaySplash() async {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  Scaffold _scaffold() {
    if (isCreated == true) {
      _delaySplash();
      return const Scaffold(
        body: Center(child: Text("Your Account Succesfull Created")),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<LoginData>(
              builder: (context, value, child) {
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
                    const SizedBox(
                      height: 15,
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
                          hintText: "Password",
                          errorText:
                              value.validatePassword ? "can't be empty" : null,
                        ),
                      ),
                    ),
                    Text(
                      errorUI,
                      style: const TextStyle(color: Colors.red),
                    ),
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
                        if (Provider.of<LoginData>(context, listen: false)
                                    .validateEmail ==
                                false &&
                            Provider.of<LoginData>(context, listen: false)
                                    .validatePassword ==
                                false) {
                          //save data firebase
                          _handleCreateWithEmail();
                        }
                      },
                      child: const Text("Create with Email"),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("create account");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Account"),
        ),
        body: ChangeNotifierProvider(
          create: (context) => LoginData(),
          builder: (BuildContext context, child) {
            return _scaffold();
          },
        ));
  }
}
