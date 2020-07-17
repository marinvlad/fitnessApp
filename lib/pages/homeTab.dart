import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ionut/classes/user.dart';
import 'package:ionut/classes/userWeight.dart';
import 'package:ionut/widgets/slideUpPanel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final User currentUser;
  final List<FlSpot> userWeightValues;
  final List<int> frequencyUserValues;
  final List<WeightData> weightData;
  final Map<double,double> ttData;
  Home(
      {this.firebaseUser,
      this.currentUser,
      this.userWeightValues,
      this.frequencyUserValues,
      this.ttData,
      this.weightData});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<double, double> weightByDayMap = Map();
  List<double> weightByDayList = [];
  int weight = 0;
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  bool option1 = true;
  double covariance;

  double maxX=47;
  void initWeightList() {
    for (var i = 0; i < widget.userWeightValues.length; i++) {
      weightByDayMap.putIfAbsent(widget.userWeightValues[i].x, () {
        return widget.userWeightValues[i].y;
      });
    }
    for (var i = 0; i < calculateMax(widget.userWeightValues); i++) {
      weightByDayList
          .add(weightByDayMap[i + 1] ?? widget.currentUser.weight.toDouble());
    }
  }

  int calculateMax(List<FlSpot> list) {
    double maxim = 0;
    for (var i = 0; i < list.length; i++) {
      if (maxim < list[i].x) maxim = list[i].x;
    }
    return maxim.toInt();
  }

  double calculateMean(List<num> list) {
    double sum = 0;
    for (var i = 0; i < list.length; i++) {
      sum += list[i].toDouble();
    }
    return sum / list.length;
  }
  double calculateMeanFromMap(Map<double, double> data){
    double sum = 0;
    for(var i = 0; i< data.length; i++){
      sum+=data[i];
    }
    return sum/data.length;
  }

  double calculateDevaiation(List<num> list) {
    double sum = 0;
    for (var i = 0; i < list.length; i++) {
      sum += (pow(list[i] - calculateMean(list), 2) / list.length);
    }
    return sum;
  }

  double calculateDeviationFromMap(Map<double, double> data){
    double sum=0;
    for(var i=0; i< data.length; i++){
      sum+=(pow(data[i] - calculateMeanFromMap(data),2)/data.length);
    }
    return sum;
  }
  void calculateCovarianceWithFreq() {
    double sum = 0;
    print("frequencyByDayList");
    print(widget.frequencyUserValues);
    for (var i = 0; i < widget.frequencyUserValues.length; i++) {
      sum += ((widget.frequencyUserValues[i].toDouble() -
              calculateMean(widget.frequencyUserValues)) *
          (weightByDayList[i] - calculateMean(weightByDayList)));
    }
    setState(() {
      covariance = (sum / weightByDayList.length.toDouble()) /
          (calculateDevaiation(widget.frequencyUserValues) *
              calculateDevaiation(weightByDayList));
      if (covariance.isNaN) covariance = 0;
    });
  }

  void calculateCovrarianceWithTT() {
    double sum = 0;
    print("caloriesByDayList");
    print(widget.ttData);
    print("weightByDayList");
    print(weightByDayList);
    for (var i = 0; i < widget.ttData.length; i++) {
      sum += ((widget.ttData[i].toDouble() -
              calculateMeanFromMap(widget.ttData)) *
          (weightByDayList[i] - calculateMean(weightByDayList)));
    }
    setState(() {
      covariance = (sum / weightByDayList.length.toDouble()) /
          (calculateDeviationFromMap(widget.ttData) *
              calculateDevaiation(weightByDayList));
      if (covariance.isNaN) covariance = 0;
    });
  }

 _initMaxX(){
   widget.weightData.forEach((val){
     if(maxX < double.parse(val.date))
        setState(() {
          maxX = double.parse(val.date);
        });
   });
 }
  @override
  void initState() {
    initWeightList();
    _initMaxX();
    setState(() {
      maxX+=10;
    });
    print(weightByDayList);
    print(widget.frequencyUserValues);
    calculateCovarianceWithFreq();
    widget.weightData
        .sort((a, b) => double.parse(a.date).compareTo(double.parse(b.date)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Grafic
        Container(
          height: MediaQuery.of(context).size.height / 2,
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                // LineChartHome(
                //   mov: widget.userWeightValues,
                // )
                Container(
                  margin: EdgeInsets.only(top:20),
                  width: MediaQuery.of(context).size.width,
                  child: LineChart(
                    LineChartData(
                        lineBarsData: widget.weightData
                            .map((g) => LineChartBarData(
                                spots: [FlSpot(double.parse(g.date), g.value)]))
                            .toList(),
                            maxY: 90,
                            maxX: maxX,
                        titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                                getTitles: (value) {
                                  if (value > 0 && value < 8)
                                    return "W1 ";
                                  else if (value >= 8 && value < 15)
                                    return "W2 ";
                                  else if (value >= 15 && value < 22)
                                    return "W3 ";
                                  else if (value >= 22 && value < 29)
                                    return "W4 ";
                                  else if (value >= 29 && value < 36)
                                    return "W5 ";
                                  else if (value >= 36 && value < 43)
                                    return "W6 ";
                                  else if (value >= 43 && value < 50)
                                    return "W7 ";
                                  else if (value >= 50 && value < 57)
                                    return "W8 ";
                                  else if (value >= 57 && value < 64)
                                    return "W9 ";
                                  else
                                    return "Wn";
                                },
                                showTitles: true,
                                interval: 7))),
                  ),
                )
              ],
            ),
          ),
        ),

        //Slide up panel
        SlidingUpPanel(
          maxHeight: MediaQuery.of(context).size.height / 2.5,
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
                    color: Colors.grey[300],
                  ),
                  Text(
                    "Today data",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[300],
                        fontFamily: 'Poppins-Bold'),
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.grey[300],
                  ),
                ],
              )),
          borderRadius: radius,
          backdropEnabled: false,
          panel: SlideUpContent(
            currentUser: widget.currentUser,
          ),
          //Covariancy
          body: ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                padding: EdgeInsets.only(left: 25, right: 25),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.5, bottom: 220),
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Correlation",
                        style:
                            TextStyle(fontFamily: "Poppins-Bold", fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                covariance.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _chooseAxisCov(context, Colors.grey[200]);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Recalculate",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Covariance indicates how two variables are related. A positive covariance means the variables are positively related, while a negative covariance means the variables are inversely related.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins-Regular"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _chooseAxisCov(BuildContext _context, Color _color) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return ChooseAxisCovWidget(
            color: _color,
            onOption1: calculateCovarianceWithFreq,
            onOption2: calculateCovrarianceWithTT,
          );
        });
  }
}

class ChooseAxisCovWidget extends StatefulWidget {
  final Color color;
  final VoidCallback onOption1;
  final VoidCallback onOption2;
  const ChooseAxisCovWidget(
      {this.color, Key key, this.onOption1, this.onOption2})
      : super(key: key);
  @override
  ChooseAxisCovWidgetState createState() => ChooseAxisCovWidgetState();
}

class ChooseAxisCovWidgetState extends State<ChooseAxisCovWidget> {
  bool option1 = true;
  final GlobalKey<ChooseAxisCovWidgetState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            bottom: 0,
            child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Material(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Weight",
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: "Poppins-Bold"),
                                ),
                              ),
                              Text(
                                "with",
                                style: TextStyle(fontFamily: "Poppins-Regular"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Choose y axis",
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: "Poppins-Bold"),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "TT",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular"),
                                  ),
                                  Checkbox(
                                    value: option1,
                                    checkColor: Colors.lightGreen[100],
                                    focusColor: Colors.lightGreen[100],
                                    activeColor: Colors.black,
                                    onChanged: (value) {
                                      setState(() {
                                        option1 = !option1;
                                      });
                                    },
                                  ),
                                  Text("PAL",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular")),
                                  Checkbox(
                                    value: !option1,
                                    checkColor: Colors.lightGreen[100],
                                    focusColor: Colors.lightGreen[100],
                                    activeColor: Colors.black,
                                    onChanged: (value) {
                                      setState(() {
                                        option1 = !option1;
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          )),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    option1
                                        ? widget.onOption1()
                                        : widget.onOption2();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40),
                                    decoration: BoxDecoration(
                                        color: widget.color,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: EdgeInsets.all(25),
                                    child: Text(
                                      "Done",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))))
      ],
    );
  }
}
