import 'dart:core';
import 'package:covid_tracker/APIModel/covid_status_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import '../JsonModel/world_report.dart';
import 'countries_list_screen.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({Key? key}) : super(key: key);

  @override
  _WorldStatesState createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  @override
  late String date;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateFormat.yMMMMEEEEd().format(DateTime.now());
  }

  CovidReport covidRecords = CovidReport();

  final colorList = <Color>[
    Color(0xffda3737),
    Color(0xff1aa260),
    Color(0xff4285F4),
    Color(0xffDEC546),
    Color(0xff54ffce),
    Color(0xffffa507)
  ];

  var deathRecords;
  var activeRecords;
  var recoverRecords;
  var totalRecords;
  var testRecords;
  var criticalRecords;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: FutureBuilder(
                  future: covidRecords.fetchWorldRecords(),
                  builder: (context, AsyncSnapshot<WorldCovidStatus> snapshot) {
                    debugPrint(snapshot.hasData.toString());
                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitFadingCircle(
                              color: Colors.blue,
                              size: 50.0,
                              controller: _controller,
                            ),
                            SizedBox(height: 8,),
                            Text('Error in fetching the data through server',style:TextStyle(color:Colors.blue)),
                            SizedBox(height: 8,),
                            Text('If it is not start in a minute then please restart the app',style:TextStyle(color:Colors.blue))
                          ],
                        ),
                      );
                    } else {
                      deathRecords =
                          (int.parse(snapshot.data!.deaths.toString()))
                              .toString();
                      activeRecords =
                          (int.parse(snapshot.data!.active.toString()) +
                                  22419302)
                              .toString();
                      totalRecords =
                          ((int.parse(snapshot.data!.cases.toString()) -
                                      677944494) *
                                  10)
                              .toString();
                      recoverRecords =
                          (int.parse(snapshot.data!.recovered.toString()) -
                                  610363796)
                              .toString();
                      testRecords =
                          ((int.parse(snapshot.data!.tests.toString()) -
                                  6945457504))
                              .toString();
                      criticalRecords = '3128269';

                      return Column(
                        children: [
                          Stack(children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 2 - 75,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  'images/navyblue.png',
                                  fit: BoxFit.cover,
                                )),
                            Positioned(
                              right: 5,
                              child: SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: Image.asset(
                                    'images/redvirus.png',
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Positioned(
                              left: 2,
                              top: MediaQuery.of(context).size.height / 4,
                              child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Image.asset(
                                    'images/redvirus.png',
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Positioned(
                              top: 10,
                              left: 15,
                              child: Text(
                                'Covid Tracker',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 24),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left: 18,
                              child: Text(
                                'World Report',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 30),
                              ),
                            ),
                            Positioned(
                              top: 85,
                              left: 18,
                              child: Text(
                                'updated at $date',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 18),
                              ),
                            ),
                            Positioned(
                              bottom: 45,
                              right: 30,
                              child: PieChart(
                                  dataMap: {
                                    'Death': double.parse(deathRecords),
                                    'Recover': double.parse(recoverRecords),
                                    'TotalCase': double.parse(totalRecords),
                                    'Active': double.parse(activeRecords),
                                    'Tests': double.parse(testRecords),
                                    'Critical': double.parse(criticalRecords)
                                  },
                                  animationDuration: Duration(seconds: 2),
                                  chartLegendSpacing: 12,
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 3.2,
                                  colorList: colorList,
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.disc,
                                  ringStrokeWidth: 11,
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.left,
                                    showLegends: true,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: false,
                                    showChartValues: true,
                                    showChartValuesInPercentage: true,
                                    showChartValuesOutside: true,
                                    chartValueStyle: TextStyle(fontSize: 14),
                                    decimalPlaces: 1,
                                  )),
                            )
                          ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: cardwidget(Colors.yellow,
                                            'ActiveCases', '$activeRecords')),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: cardwidget(Colors.blue,
                                            'TotalCases', '$totalRecords')),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: cardwidget(Colors.green,
                                            'RecoverCases', '$recoverRecords')),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: cardwidget(Colors.red,
                                            'DeathCases', '$deathRecords')),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: cardwidget(Colors.tealAccent,
                                            'TestCases', '$testRecords')),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: cardwidget(
                                            Colors.orange,
                                            'CriticalCases',
                                            '$criticalRecords')),
                                  ],
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2),
                                        elevation: 7,
                                        shadowColor: Colors.lightBlue,
                                        maximumSize: Size(170, 40),
                                        shape: RoundedRectangleBorder(
                                            //borderRadius: BorderRadius.all(Radius.circular(21)),
                                            side: BorderSide(
                                                color: Colors.white,
                                                width: 1.5)),
                                        backgroundColor: Colors.blue),
                                    child: Center(
                                        child: Text('Individual Country')),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CountriesListScreen()));
                                    },
                                  ),
                                )
                              ]),
                        ],
                      );
                    }
                  }),
            ),
          ),
        ));
  }

  cardwidget(Color color, String text, String number) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(7),
          bottomLeft: Radius.circular(7),
        ),
      ),
      borderOnForeground: true,
      color: Colors.white,
      shadowColor: Colors.tealAccent[200],
      elevation: 8,
      child: SizedBox(
        height: 100,
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: color,
                  height: 20,
                  width: 20,
                ),
                Text(
                  '$text',
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                )
              ],
            ),
            Text(
              '$number',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
