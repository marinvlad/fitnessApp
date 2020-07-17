import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionut/pages/home.dart';
import 'package:ionut/pages/login.dart';
import 'package:ionut/pages/signUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  void verifyCurrentUser()async{
    var currentUser = await FirebaseAuth.instance.currentUser();
      if(currentUser!=null)
        {
          Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage(user: currentUser,)));
        }
  }

  @override
  void initState() {
    verifyCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              alignment: Alignment.centerRight,
              child: Image.asset('assets/images/startPageBackground.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Text(
              "Unleash your \n health",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white),
                    child: Text(
                      "Start now",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                     Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white),
                    child: Text(
                      "Log In",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
