import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/HomeScreen.dart';
import '../login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

//when 1st time any user login app then i store email and password in local storage
//then next time when user open app then I check email is available or not
//if I found email then no need to login again
//and for this i code here
  late SharedPreferences sharedPreferences;
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  void getEmail() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString('email')!;
      password = sharedPreferences.getString('pass')!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/logo_.png'),
      splashIconSize: 100,
      nextScreen: email.isEmpty?LoginScreen():HomeScreen(),
      backgroundColor: Colors.black,
      duration: 4000,
      splashTransition: SplashTransition.scaleTransition,
      //pageTransitionType: PageTransitionType.scale,
    );
  }
}