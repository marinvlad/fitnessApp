import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
class FetchDataScreen extends StatefulWidget {
  @override
  _FetchDataScreenState createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Grafic
        Container(
          height: MediaQuery.of(context).size.height / 2,
          color: Color(0XFF5b8c5a),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child:
               CircularProgressIndicator()
              ,
            ),
          ),
        ),

        //Slide up panel
        SlidingUpPanel(
          maxHeight: MediaQuery.of(context).size.height,
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
          panel: Container(child: CircularProgressIndicator(),),
          //Covariancy
          body: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            padding: EdgeInsets.only(left: 25, right: 25),
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.5, bottom: 220),
            height: MediaQuery.of(context).size.height * 0.45,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}