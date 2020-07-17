import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionut/pages/home.dart';
import 'package:ionut/widgets/splasScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUpDetails extends StatefulWidget {
  final FirebaseUser user;
  SignUpDetails({this.user});
  @override
  _SignUpDetailsState createState() => _SignUpDetailsState();
}

class _SignUpDetailsState extends State<SignUpDetails> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _wSize = TextEditingController();
  bool gender = false;

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    _wSize.dispose();
    super.dispose();
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
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Data about you",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            controller: _name,
                            decoration: InputDecoration(
                                hintText: "Name", border: InputBorder.none),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            controller: _age,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Age", border: InputBorder.none),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            controller: _weight,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Weight (kg)",
                                border: InputBorder.none),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            controller: _height,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Height (cm)",
                                border: InputBorder.none),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                            controller: _wSize,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Wrist size (cm)",
                                border: InputBorder.none),
                          ),
                        )),
                  ),
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        activeColor: Colors.black,
                        checkColor: Color(0XFF5b8c5a),
                        value: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                      Text("Male"),
                      Checkbox(
                        activeColor: Colors.black,
                        checkColor: Color(0XFF5b8c5a),
                        value: !gender,
                        onChanged: (value) {
                          setState(() {
                            gender = !gender;
                          });
                        },
                      ),
                      Text("Female"),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      bool userReady = false;
                      bool userWeightReady = false;
                      bool userCaloriesReady = false;
                      await Firestore.instance
                          .collection("Users")
                          .document(widget.user.uid)
                          .setData({
                        'name': _name.text.toString(),
                        'age': _age.text.toString(),
                        'weight': _weight.text.toString(),
                        'height': _height.text.toString(),
                        'wrist size': _wSize.text.toString(),
                        'gender': gender ? 'male' : 'female'
                      }).then((onValue) {
                        setState(() {
                          userReady = true;
                        });
                      });
                      await Firestore.instance
                          .collection("Users")
                          .document(widget.user.uid)
                          .collection("Weight values")
                          .add({
                        "value": _weight.text,
                        "date": DateTime.now().day.toString()
                      }).then((onValue) {
                        setState(() {
                          userWeightReady = true;
                        });
                      });
                      await Firestore.instance
                        .collection("Users")
                        .document(widget.user.uid)
                        .collection("Kcal values")
                        .document(DateTime.now().month.toString() + DateTime.now().day.toString())
                        .setData({
                          "value": 0.toString(),
                          "date": DateTime.now().day.toString()
                        });
                      SharedPreferences _prefs = await SharedPreferences.getInstance();
                      _prefs.setInt("lastDayCalories", 0);
                      if (userWeightReady && userReady)
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreeen(user: widget.user,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                              color: Color(0XFF5b8c5a),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Create your account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
