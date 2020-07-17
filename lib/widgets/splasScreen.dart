import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionut/pages/home.dart';
import 'package:ionut/pages/homeTab.dart';

class SplashScreeen extends StatelessWidget {
  final FirebaseUser user;
  SplashScreeen({this.user});
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
    'assets/splash.flr',
    HomePage(user: user,),
    startAnimation: 'intro',
    backgroundColor: Color(0xff181818),
  );
  }
}