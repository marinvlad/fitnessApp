import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionut/pages/home.dart';
import 'package:ionut/pages/homeTab.dart';

import '../main.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => StartPage()));
            FirebaseAuth.instance.signOut();
          },
          child: Center(
            child: Text(
              "Exit",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
          ),
        ));
  }
}
