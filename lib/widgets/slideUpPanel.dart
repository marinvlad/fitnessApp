import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionut/classes/user.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlideUpContent extends StatefulWidget {
  final User currentUser;
  SlideUpContent({this.currentUser,Key key}):super(key:key);
  @override
  SlideUpContentState createState() => SlideUpContentState();
}

class SlideUpContentState extends State<SlideUpContent> {
  double bmr = 0;
  int caloriesProgress=0;
  List<String> _objTitle = ["Breakfast", "Lunch", "Dinner", "Snacks"];
  List<Color> _objColors = [
    Colors.green[200],
    Colors.red[300],
    Colors.green[400],
    Colors.yellow[300]
  ];
  List<String> _objEmoji = ["🥑", "🥩", "🥗", "🍌"];
  List<String> _objDescription = [
    "",
    "",
    "",
    ""
  ];
  void getCaloriesProgress() async {
    try {
      Firestore.instance
          .collection("Users")
          .document(widget.currentUser.uid)
          .collection("Kcal values")
          .document(
              DateTime.now().month.toString() + DateTime.now().day.toString())
          .get()
          .then((onValue) {
        if (onValue.exists)
          setState(() {
            caloriesProgress = int.parse(onValue.data["value"]);
          });
        else
          caloriesProgress = 0;
      });
    } catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    getCaloriesProgress();
    setState(() {
      bmr = (10 * widget.currentUser.weight) +
          (6.25 * widget.currentUser.height) -
          (5 * widget.currentUser.age) +
          (widget.currentUser.gender == "male" ? 5 : -161);
    });
    print(bmr);
    print(caloriesProgress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "Hi,",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.currentUser.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 25, right: 25, top: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.deepPurple[700],
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Progress",
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      Text("For Today",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 25)),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  padding: EdgeInsets.all(30.0),
                  child: Center(
                      child: Text(
                    (caloriesProgress / (bmr*1.3) * 100).toStringAsFixed(1)+"%",
                    style: TextStyle(
                        color: Colors.deepPurple[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFFC9D6FF), Color(0XFFE2E2E2)]),
                      shape: BoxShape.circle),
                )
              ],
            ),
          ),
        ),
     
      ],
    );
  }
}
