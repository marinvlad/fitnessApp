import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
class LineChartCalori extends StatefulWidget {
  final List<FlSpot> mov;
  LineChartCalori({this.mov});
  @override
  _LineChartCaloriState createState() => _LineChartCaloriState();
}

class _LineChartCaloriState extends State<LineChartCalori> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Food',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                       sampleData1(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {
          print(touchResponse);
        },
        handleBuiltInTouches: true,
      ),
      gridData: const FlGridData(
        show: false,
      ),
      axisTitleData: FlAxisTitleData(
        show: true,
        bottomTitle: AxisTitle(
          margin: 30,
          showTitle: true,
          titleText: "Kcal intake",
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300
          )
        )
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 1,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 1,
          interval: 6.5,
          getTitles: (value) {
            return value.toInt().toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return value.toInt().toString();
            
          },
          margin: 8,
          reservedSize: 40,
          interval: 500
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 4,
          ),
          left: BorderSide(color: Colors.white, width: 4),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 1,
      maxX: 62,
      maxY: 3500,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      //verde
      spots: widget.mov,
      isCurved: true,
      colors: [
        Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    // final LineChartBarData lineChartBarData2 = LineChartBarData(
    //   //Mov
    //   spots: widget.mov,
    //   isCurved: true,
    //   colors: [
    //     Color(0xffaa4cfc),
    //   ],
    //   barWidth: 8,
    //   isStrokeCapRound: true,
    //   dotData: FlDotData(
    //     show: false,
    //   ),
    //   belowBarData: BarAreaData(show: false, colors: [
    //     Color(0x00aa4cfc),
    //   ]),
    // );
    // LineChartBarData lineChartBarData3 = LineChartBarData(
    //   //Albastru
    //   spots: const [
    //     FlSpot(1, 40),
    //     FlSpot(9, 50),
    //     FlSpot(13, 60),
    //     FlSpot(19, 70),
    //     FlSpot(26, 80),
    //   ],
    //   isCurved: true,
    //   colors: const [
    //     Color(0xff27b6fc),
    //   ],
    //   barWidth: 8,
    //   isStrokeCapRound: true,
    //   dotData: const FlDotData(
    //     show: false,
    //   ),
    //   belowBarData: const BarAreaData(
    //     show: false,
    //   ),
    // );
    return [
      lineChartBarData1,
      // lineChartBarData2,
      // lineChartBarData3,
    ];
  }

  

  List<LineChartBarData> linesBarData2() {
    return [
      // const LineChartBarData(
      //   spots: [
      //     FlSpot(1, 1),
      //     FlSpot(3, 4),
      //     FlSpot(5, 1.8),
      //     FlSpot(7, 5),
      //     FlSpot(10, 2),
      //     FlSpot(12, 2.2),
      //     FlSpot(13, 1.8),
      //   ],
      //   isCurved: true,
      //   curveSmoothness: 0,
      //   colors: [
      //     Color(0x444af699),
      //   ],
      //   barWidth: 4,
      //   isStrokeCapRound: true,
      //   dotData: FlDotData(
      //     show: false,
      //   ),
      //   belowBarData: BarAreaData(
      //     show: false,
      //   ),
      // ),
      const LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2),
          FlSpot(7, 3),
          FlSpot(15, 4),
          FlSpot(20, 5),
          FlSpot(60, 7),
        ],
        isCurved: true,
        colors: [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          Colors.white,
        ]),
      ),
      // const LineChartBarData(
      //   spots: [
      //     FlSpot(1, 3.8),
      //     FlSpot(3, 1.9),
      //     FlSpot(6, 5),
      //     FlSpot(10, 3.3),
      //     FlSpot(13, 4.5),
      //   ],
      //   isCurved: true,
      //   curveSmoothness: 0,
      //   colors: [
      //     Color(0x4427b6fc),
      //   ],
      //   barWidth: 2,
      //   isStrokeCapRound: true,
      //   dotData: FlDotData(
      //     show: true,
      //   ),
      //   belowBarData: BarAreaData(
      //     show: false,
      //   ),
      // ),
    ];
  }
}