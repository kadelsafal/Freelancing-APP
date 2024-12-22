import 'package:flutter/material.dart';
import 'package:freelancing/Login/login_config.dart';

import 'package:freelancing/navigationbar/navigation.dart';
import '../Login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      open_Home();
    });

    // TODO: implement initState
    super.initState();
  }

  void open_Home() {
    Navigator.pushReplacement(
      (context),
      MaterialPageRoute(builder: (context) => Login_Screen()),
    );
  }

  void open_login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash Screen")),
    );
  }
}
