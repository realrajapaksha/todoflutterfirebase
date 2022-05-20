import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoflutterfirebase/screens/home.dart';
import 'package:todoflutterfirebase/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  Future<void> _delaySplash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = (prefs.getString("username") ?? "none");
    Future.delayed(const Duration(seconds: 2), () {
      if (username != "none") {
        print("home");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            ModalRoute.withName("/Home"));
      } else {
        print("login");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            ModalRoute.withName("/Home"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _delaySplash();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("tODO with Flutter"),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
