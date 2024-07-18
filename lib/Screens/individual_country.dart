import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';

class IndividualCountry extends StatefulWidget {
  final String image;
  final String name;
  final int totalCases, totalDeaths, totalRecovered, active, critical, test;

  const IndividualCountry({
    Key? key,
    required this.image,
    required this.name,
    required this.totalCases,
    required this.totalDeaths,
    required this.totalRecovered,
    required this.active,
    required this.critical,
    required this.test,
  }) : super(key: key);

  @override
  _IndividualCountryState createState() => _IndividualCountryState();
}

class _IndividualCountryState extends State<IndividualCountry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.5,
        shadowColor: Colors.white,
        elevation: 8,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: <Widget>[
                // Stroked text as border.
                Text(
                  widget.name.toUpperCase(),
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 28,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..color = Colors.blue[700]!,
                  ),
                ),
                // Solid text as fill.
                Text(
                  widget.name.toUpperCase(),
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 28,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            alignment: Alignment.center,
            image: NetworkImage(widget.image),
            fit: BoxFit.fitWidth,
            onError: (Object exception, StackTrace? stacktrace) {
              const CircularProgressIndicator(color: Colors.blue);
            },
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: cardwidget(
                    Colors.blue, 'TotalCases', widget.totalCases.toString()),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: cardwidget(
                    Colors.yellow, 'ActiveCases', widget.active.toString()),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: cardwidget(Colors.green, 'TotalRecovered',
                    widget.totalRecovered.toString()),
              ),
              const SizedBox(height: 285),
              Align(
                alignment: Alignment.centerLeft,
                child: cardwidget(Colors.redAccent, 'TotalDeaths',
                    widget.totalDeaths.toString()),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: cardwidget(
                    Colors.tealAccent, 'TestCases', widget.test.toString()),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: cardwidget(
                    Colors.orange, 'CriticalCases', widget.critical.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cardwidget(Color color, String text, String number) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(7),
            bottomLeft: Radius.circular(7),
          ),
        ),
        color: Colors.white,
        shadowColor: Colors.tealAccent[200],
        elevation: 8,
        child: SizedBox(
          height: 40,
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: color,
                height: 20,
                width: 20,
              ),
              Text(
                '$text:',
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
              Text(
                '$number',
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
