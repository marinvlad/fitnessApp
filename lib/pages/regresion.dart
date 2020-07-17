import 'package:bezier_chart/bezier_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ionut/classes/user.dart';
import 'package:ionut/classes/userWeight.dart';
import 'package:ionut/widgets/slideUpPanel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

class Regresion extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final User currentUser;
  final List<WeightData> weightData;
  Regresion({this.firebaseUser,this.currentUser, this.weightData});
  @override
  _RegresionState createState() => _RegresionState();
}

class _RegresionState extends State<Regresion> {
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  _getMaximFromWeightData(){
    int maxim=0;
    for(WeightData data in widget.weightData){
        if(maxim<int.parse(data.date))
          maxim = int.parse(data.date);
    }
    return maxim;
  }

  _calculatePredictionFor(int day){
    double mean = 1;
    double sum = 0;
    for(WeightData data in widget.weightData){
      sum+=data.value;
    }
    mean=sum/widget.weightData.length;

    return WeightData(mean+1,(_getMaximFromWeightData()+day).toString());
  }

  @override
  void initState() {
    widget.weightData.add(_calculatePredictionFor(7));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Grafic
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          color: Color(0XFF5b8c5a),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top:10),
                  height: MediaQuery.of(context).size.height / 2.7,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child:Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: MediaQuery.of(context).size.width,
                  child: LineChart(
                    LineChartData(
                      lineBarsData:
                        widget.weightData.map((g)=> LineChartBarData(
                          spots: [
                            FlSpot(double.parse(g.date),g.value)
                          ]
                        )).toList(),
                        maxY: 90,
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                            getTitles: (value){
                              if(value>0 && value < 8)
                                return "W1 ";
                              else
                              if(value>=8 && value < 15)
                                return "W2 ";
                              else
                              if(value>=15 && value <22)
                                return "W3 ";
                              else
                              if(value>=22 && value<29)
                              return "W4 ";
                              else 
                              if(value>=29 && value<36)
                              return "W5 ";
                              else
                              if(value>=36 && value<43)
                              return "W6 ";
                              else
                              if(value>=43 && value<50)
                              return "W7 ";
                              else
                              if(value>=50 && value<57)
                              return "W8 ";
                              else
                              if(value>=57 && value<64)
                              return "W9 ";
                              else
                              return "Wn";
                            },
                            showTitles: true,
                            interval: 7
                          )
                        )
                    ),
                  ))
                )
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
          panel: SlideUpContent(currentUser: widget.currentUser,),
          //Text
          body: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.only(left: 25, right: 25),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.5, bottom: 220),
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:30.0),
                    child: Text("Time series for weight",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:30.0),
                    child: Text("Time series regression is a statistical method for predicting a future response based on the response history (known as autoregressive dynamics) and the transfer of dynamics from relevant predictors. Time series regression can help you understand and predict the behavior of dynamic systems from experimental or observational data.",
                      textAlign: TextAlign.center,style: TextStyle(color: Colors.blueGrey),)),
                ],
              )),
        ),
      ],
    );
  }
}
