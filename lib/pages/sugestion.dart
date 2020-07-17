import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionut/classes/user.dart';
import 'package:ionut/widgets/slideUpPanel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Sugestion extends StatefulWidget {
  final User currentUser;
  Sugestion({this.currentUser});
  @override
  _SugestionState createState() => _SugestionState();
}

class _SugestionState extends State<Sugestion> {
  int todayCalories = 0;
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  var idealWeightValue;
  var bmiValue;
  var bmr;

  void getTodayCalories() async{
    try{
      Firestore.instance
        .collection("Users")
        .document(widget.currentUser.uid)
        .collection("Kcal values")
        .document(DateTime.now().month.toString() + DateTime.now().day.toString())
        .get()
        .then((onValue) {
      if(onValue.exists)
      setState(() {
        todayCalories = int.parse(onValue.data["value"]);
      });
      else
      todayCalories = 0;
    });
    }catch(e){
      print(e.message);
    }
  }

  @override
  void initState() {
    getTodayCalories();
    idealWeightValue =
      (widget.currentUser.gender =="male"? 48 : 45.5 )
      + (widget.currentUser.gender =="male"? 2.7 : 2.3) * ((widget.currentUser.height * 0.393701) - 5 * 12);
      
    bmiValue =
        widget.currentUser.weight / (pow(widget.currentUser.height / 100, 2));
    bmr = (10 * widget.currentUser.weight) + (6.25 * widget.currentUser.height) -
        (5 * widget.currentUser.age) + (widget.currentUser.gender == "male"? 5 : -161);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Grafic
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          color: Color(0XFF5b8c5a),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 2.7,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Your ideal weight:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.lightGreen[100]),
                              ),
                              Text(
                                idealWeightValue.toStringAsFixed(2) + " Kg",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.lightGreen[100]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.lightGreen[100],
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Your current BMI:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blueGrey),
                              ),
                              Text(
                                bmiValue.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Your kcal remains for today:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.lightGreen[100]),
                              ),
                              Text(
                                ((bmr*1.3) - todayCalories.toDouble()).toStringAsFixed(0),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.lightGreen[100]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),

        //Slide up panel
        SlidingUpPanel(
          maxHeight: MediaQuery.of(context).size.height/2.5,
          margin: EdgeInsets.only(bottom: 40),
          collapsed: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.blueGrey,
                  ),
                  Text(
                    "Today data",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.blueGrey,
                  ),
                ],
              )),
          borderRadius: radius,
          backdropEnabled: false,
          panel: SlideUpContent(
            currentUser: widget.currentUser,
          ),
          //Text
          body: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.only(left: 25, right: 25),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.7, bottom: 220),
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Sugestions",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "To improve your bmi you should:",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            ),
                            Text(
                             BMIBrain(bmiValue),
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[200]),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }

  String BMIBrain(double _bmiValue) {
    if(_bmiValue < 18.0)
      return "You should eat more and do more exercices";
    if(_bmiValue > 18.0 && _bmiValue < 25.0)
      return "Your doing great. Keep up the good job";
    else
      return "You should eat less and do more exercices";
  }
}
