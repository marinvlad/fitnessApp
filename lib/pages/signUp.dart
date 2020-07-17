
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionut/pages/signUpInfo.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: KeyboardAvoider(
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
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(left:20.0,right:20.0,bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.2,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Hey, wellcome",
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),

                        //Input fields
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, right: 15.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: TextField(
                                        controller: _email,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 15.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: TextField(
                                        obscureText: true,
                                        controller: _password,
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            border: InputBorder.none),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  try {
                                    FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _email.text,
                                            password: _password.text)
                                        .then((onValue) async{
                                      print(onValue.user.uid);                              
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUpDetails(user: onValue.user,)));
                                    });
                                  } catch (e) {}
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Color(0XFF5b8c5a),
                                      borderRadius: BorderRadius.circular(20.0)),
                                  child: Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        //Footer
                        Container(
                          padding: EdgeInsets.only(bottom: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Divider(
                                color: Colors.black,
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "By clicking next you agree with terms and conditions",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w200),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
