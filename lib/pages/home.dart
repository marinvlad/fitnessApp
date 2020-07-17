import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ionut/classes/user.dart';
import 'package:ionut/classes/userWeight.dart';
import 'package:ionut/pages/calories.dart';
import 'package:ionut/pages/regresion.dart';
import 'package:ionut/pages/sugestion.dart';
import 'package:ionut/widgets/fetchDataScreen.dart';
import 'package:ionut/widgets/navbar.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:weight_slider/weight_slider.dart';

import 'homeTab.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  HomePage({this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Selected tab index
  int selectedTab = 0;

  //Current user variable
  User _currentUser;
  double weight = 50;
  int todayCalories;
  double tt = 0;
  //verify loading variables
  bool fetchWeightDataReady = false;
  bool fetchCaloriesReady = false;
  bool fetchUserDataReady = false;
  int lastDate = 0;
  //User data lists
  List<FlSpot> weightUserValues = [];
  List<int> frequencyUserValues = [];
  List<FlSpot> ttUserGraphicValues = [];
  List<WeightData> weightData = [];
  List<int> caloriesByDay = [];
  Map<double, double> ttData = new Map();

  int getMaximFromList(List<DocumentSnapshot> lista){
    int maxim = 0;
    for(var i=0; i<lista.length;i++)
    {
      var val = int.parse(lista[i].data["date"]);
      if(maxim < val)
        {
          maxim = val;
        }
    }
    return maxim;
  }

  void initFrequencyUserValues(int size){
    for(var i=0; i<size; i++)
    {
      frequencyUserValues.add(0);
    }
  }

  void initCaloriesUserValues(int size){
    for(var i=0; i<size; i++)
    {
      caloriesByDay.add(0);
    }
  }

  void fetchCaloriesForToday() async{
    try{
      Firestore.instance
        .collection("Users")
        .document(widget.user.uid)
        .collection("Kcal values")
        .document(DateTime.now().month.toString() + DateTime.now().day.toString())
        .get()
        .then((onValue) {
      if(onValue.exists)
      setState(() {
        todayCalories = onValue.data["value"];
      });
      else
      todayCalories = 0;
    });
    }catch(e){
      print(e.message);
    }
  }
  void fetchWeightData() async{
    fetchWeightDataReady = false;
    weightUserValues = [];
    weightData = [];
    frequencyUserValues = [];
    await Firestore.instance
        .collection("Users")
        .document(widget.user.uid)
        .collection("Weight values")
        .getDocuments()
        .then((onValue) {
      initFrequencyUserValues(getMaximFromList(onValue.documents));
      for (int i = 0; i < onValue.documents.length; i++)
        {
          
          weightData.add(WeightData(double.parse(onValue.documents[i].data["value"]), onValue.documents[i].data["date"]));
          weightUserValues.add(FlSpot(double.parse(onValue.documents[i].data["date"]),
            double.parse(onValue.documents[i].data["value"])));
          frequencyUserValues[int.parse(onValue.documents[i].data["date"])-1]++;

          if(lastDate < int.parse(onValue.documents[i].data["date"]))
            lastDate = int.parse(onValue.documents[i].data["date"]);
        }
      print(frequencyUserValues);
      print(weightUserValues.length);
      setState(() {
        fetchWeightDataReady = true;
      });
    });
  }
  void fetchTTData() async{
    fetchCaloriesReady = false;
    ttUserGraphicValues = [];
    caloriesByDay = [];
    await Firestore.instance
      .collection("Users")
      .document(widget.user.uid)
      .collection("TT")
      .getDocuments()
      .then((onValue){
    initCaloriesUserValues(getMaximFromList(onValue.documents));
    for(int i=0; i < onValue.documents.length; i++)
    {
      print(onValue.documents[i].data);
      ttUserGraphicValues.add(
        FlSpot(double.parse(onValue.documents[i].data["date"]),
        double.parse(onValue.documents[i].data["value"])));
        ttData.putIfAbsent(double.parse(onValue.documents[i].data["date"]),
        ()=>double.parse(onValue.documents[i].data["value"]));
        // caloriesByDay[int.parse(onValue.documents[i].data["date"])-1] = 
        // int.parse(onValue.documents[i].data["value"]);
    }
    setState(() {
      fetchCaloriesReady = true;
    });
    });
  }
  void fetchUserData() async {
    await Firestore.instance
        .collection("Users")
        .document(widget.user.uid)
        .get()
        .then((onValue) {
      int age = int.parse(onValue["age"]);
      double weight = double.parse(onValue["weight"]);
      int height = int.parse(onValue["height"]);
      int wristSize = int.parse(onValue["wrist size"]);
      String gender = onValue["gender"];
      _currentUser = new User(
          uid: widget.user.uid,
          name: onValue["name"],
          age: age,
          weight: weight,
          height: height,
          wristSize: wristSize,
          gender: gender);
      setState(() {
        fetchUserDataReady = true;
      });
    });
  }
  
  @override
  void initState() {
    fetchUserData();
    fetchWeightData();
    fetchTTData();   
    fetchCaloriesForToday();
 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.grey[200],
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            fetchUserDataReady==true && fetchWeightDataReady && fetchCaloriesReady?
            selectedTab == 0
                ? Home(
                    firebaseUser: widget.user,
                    currentUser: _currentUser,
                    userWeightValues: weightUserValues,
                    frequencyUserValues: frequencyUserValues,
                    ttData: ttData,
                    weightData: weightData,
                  )
                : selectedTab == 1
                    ? CaloriesGraphic(
                        currentUser: _currentUser,
                        firebaseUser: widget.user,
                        caloriesUserValues: ttUserGraphicValues,
                        onAdd: fetchTTData
                      )
                    : selectedTab == 2
                        ? Regresion(
                            firebaseUser: widget.user,
                            currentUser: _currentUser,
                            weightData: weightData,
                          )
                        : Sugestion(
                            currentUser: _currentUser,
                          ):
                          FetchDataScreen(),
            //Bottom nav bar
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius:
                          20.0, // has the effect of softening the shadow
                      spreadRadius:
                          5.0, // has the effect of extending the shadow
                      offset: Offset(
                        10.0, // horizontal, move right 10
                        10.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: SizedBox(),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //Home icon
                    InkWell(
                      onTap: () {
                        setState(() {                      
                          selectedTab = 0;
                        });
                      },
                      child: Icon(
                        Icons.home,
                        size: 30,
                        color:
                            selectedTab == 0 ? Color(0xFF56ab2f) : Colors.black,
                      ),
                    ),
                    //Grafic calorii
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedTab = 1;
                        });
                      },
                      child: Icon(
                        Icons.fastfood,
                        size: 30,
                        color:
                            selectedTab == 1 ? Color(0xFF56ab2f) : Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _addDataDialog(context);
                      },
                      child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xFF56ab2f), Color(0XFFa8e063)]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green,
                                blurRadius:
                                    20.0, // has the effect of softening the shadow
                                spreadRadius:
                                    2.0, // has the effect of extending the shadow
                                offset: Offset(
                                  5.0, // horizontal, move right 10
                                  5.0, // vertical, move down 10
                                ),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            size: 80,
                            color: Colors.white,
                          )),
                    ),
                    //Grafic 2
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedTab = 2;
                        });
                        
                      },
                      child: Icon(
                        Icons.show_chart,
                        size: 30,
                        color:
                            selectedTab == 2 ? Color(0xFF56ab2f) : Colors.black,
                      ),
                    ),
                    //Grafic 3
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedTab = 3;
                        });
                        fetchUserData();
                      },
                      child: Icon(
                        Icons.bubble_chart,
                        size: 30,
                        color:
                            selectedTab == 3 ? Color(0xFF56ab2f) : Colors.black,
                      ),
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

  void _addDataDialog(BuildContext _context) {
    showDialog(
        context: _context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Positioned(
                  bottom: 0,
                  child: Container(
                      height: 700,
                      width: MediaQuery.of(context).size.width,
                      child: Material(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Insert your today's weight",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width - 100,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Color(0XFF5b8c5a),
                                    borderRadius: BorderRadius.circular(20)),
                                //Cantar
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      customColors: CustomSliderColors(
                                        progressBarColor: Colors.green,
                                        trackColor: Colors.white,
                                        shadowColor: Colors.white
                                      ),
                                      infoProperties: InfoProperties(
                                        mainLabelStyle: TextStyle(color: Colors.white, fontSize: 25),
                                        modifier: (val)=> val.toStringAsFixed(1)
                                      )
                                    ),
                                    min: 50,
                                    max: 100,
                                    initialValue: 65,
                                    onChange: (val) {
                                      setState(() {
                                        weight = val;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Insert your today's training time (mins)", style: 
                                TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      customColors: CustomSliderColors(
                                        progressBarColor: Colors.green,
                                        trackColor: Colors.black,
                                        shadowColor: Colors.white,
                                        dotColor: Colors.black,
                                      ),
                                      infoProperties: InfoProperties(
                                        mainLabelStyle: TextStyle(color: Colors.black, fontSize: 25),
                                        modifier: (val)=> val.toStringAsFixed(1)
                                      )
                                    ),
                                    min: 20,
                                    max: 180,
                                    initialValue: 60,
                                    onChange: (val) {
                                      setState(() {
                                       tt = val;
                                      });
                                    },
                                  ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {                                       
                                          Firestore.instance
                                              .collection("Users")
                                              .document(widget.user.uid)
                                              .collection("Weight values")
                                              .add({
                                            'date':
                                                (lastDate+3).toString(),
                                            'value': weight.toString()
                                          });
                                           Firestore.instance
                                              .collection("Users")
                                              .document(widget.user.uid)
                                              .collection("TT")
                                              .add({
                                            'date':
                                                (lastDate+3).toString(),
                                            'value': tt.toString()
                                          });
                                          Firestore.instance
                                            .collection("Users")
                                            .document(widget.user.uid)
                                            .updateData({
                                              "weight" : weight.toString()
                                            });
                                          weightUserValues.add(FlSpot(
                                              DateTime.now().day.toDouble(),
                                              weight.toDouble()));
                                          Navigator.pop(context);
                                          fetchWeightData();
                                        },
                                        child: Container(
                                          height: 50,
                                          margin: EdgeInsets.all(30),
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Color(0XFF5b8c5a),
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
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
