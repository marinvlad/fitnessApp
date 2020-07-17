import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ionut/classes/user.dart';
import 'package:ionut/pages/lineChartCalori.dart';
import 'package:ionut/widgets/slideUpPanel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CaloriesGraphic extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final User currentUser;
  final List<FlSpot> caloriesUserValues;
  final VoidCallback onAdd;
  CaloriesGraphic({
    this.firebaseUser, 
    this.currentUser,
    this.caloriesUserValues,
    this.onAdd,
    Key key
    }) : super(key:key);
  @override
  _CaloriesGraphicState createState() => _CaloriesGraphicState();
}

class _CaloriesGraphicState extends State<CaloriesGraphic> {

  final GlobalKey<SlideUpContentState> _key = GlobalKey();

  int weight = 0;
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  List<String> _addFoodCategoryes = [
    "Add Breakfast",
    "Add Lunch",
    "Add Dinner",
    "Add snack"
  ];
  List<String> _addFoodEmoji = ["🥑", "🥩", "🥗", "🍌"];
  List<Color> _addFoodColor = [
    Colors.green[200],
    Colors.red[300],
    Colors.green[400],
    Colors.yellow[300]
  ];
  List<String> _addFoodRecomandation = [
    "It should be around 300 to 400 kcal",
    "It should be around 500 to 700 kcal",
    "It should be around 500 to 700 kcal",
    "It should be less than 200 kcal"
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Grafic
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height / 2,
        //   color: Color(0XFF5b8c5a),
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 20, right: 20),
        //     child: Column(
        //       children: <Widget>[
        //         LineChartCalori(
        //           mov: widget.caloriesUserValues,
        //         )
        //       ],
        //     ),
        //   ),
        // ),

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
            key: _key,
            currentUser: widget.currentUser,
          ),
          //Food list
          body: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.only(left: 25, right: 25),
            margin: EdgeInsets.only(
                top: 50, bottom: 250),
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView.builder(
              itemCount: _addFoodCategoryes.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                      padding: EdgeInsets.all(15),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: _addFoodColor[index],
                                borderRadius: BorderRadius.circular(15)),
                            width: 50,
                            child: Center(
                                child: Text(
                              _addFoodEmoji[index],
                              style: TextStyle(fontSize: 35),
                            )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _addFoodCategoryes[index],
                                textAlign: TextAlign.start,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _addFoodRecomandation[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueGrey),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              _addFoodDialog(context, _addFoodColor[index],
                                  _addFoodCategoryes[index]);
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Color(0XFF5b8c5a),
                              size: 30,
                            ),
                          )
                        ],
                      )),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _addFoodDialog(
      BuildContext _context, Color _foodColor, String _categoryName) {
    var _kcalController = TextEditingController();
    int numberOfKcal = 0;
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Positioned(
                  bottom: 0,
                  child: Container(
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      child: Material(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                decoration: BoxDecoration(
                                    color: _foodColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                        "Enter your ${_categoryName.split(" ")[1]} meal Kcal",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black
                                        ),
                                        ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[                                       
                                        Container(
                                          width: 80,
                                          child: TextField(
                                            controller: _kcalController,
                                            decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w200
                                                ),
                                                hintText: "Kcal"),
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                     
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () async{
                                           try{ 
                                          int _temp;                                       
                                          await Firestore.instance
                                            .collection("Users")
                                            .document(widget.currentUser.uid)
                                            .collection("Kcal values")
                                            .document(DateTime.now().month.toString() + DateTime.now().day.toString())
                                            .get()
                                            .then((onValue) {
                                                if(onValue.exists)
                                                setState(() {
                                                  _temp = int.parse(onValue.data["value"]);
                                                 _temp +=  int.parse(_kcalController.text);
                                                });
                                                else
                                                _temp = 0;
                                              });
                                          print(_temp);
                                                                                                        
                                            await Firestore.instance
                                              .collection("Users")
                                              .document(widget.currentUser.uid)
                                              .collection("Kcal values")
                                              .document(DateTime.now().month.toString() + DateTime.now().day.toString())
                                              .setData({
                                                "value": _temp.toString(),
                                                "date": DateTime.now().day.toString()
                                              });
                                          }catch(e){
                                            print(e);
                                          }
                                          widget.onAdd();
                                          _key.currentState.getCaloriesProgress();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 40),
                                          decoration: BoxDecoration(
                                              color: _foodColor,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          padding: EdgeInsets.all(25),
                                          child: Text(
                                            "Add",
                                            style:
                                                TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.all(30),
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[350],
                                              shape: BoxShape.circle),
                                          child: Icon(Icons.close),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ))))
            ],
          );
        });
  }
}
