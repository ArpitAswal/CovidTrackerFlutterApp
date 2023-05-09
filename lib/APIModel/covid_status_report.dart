
import 'dart:convert';
import 'package:covid_tracker/APIModel/app_url.dart';
import 'package:covid_tracker/JsonModel/world_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class CovidReport {

  Future<WorldCovidStatus> fetchWorldRecords() async {
    final response = await http.get(Uri.parse(AppUrl.WorldAPI));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint(data['records'].toString());
      return WorldCovidStatus.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    var data ;
    final response = await http.get(Uri.parse(AppUrl.CountiesAPI));
    if (response.statusCode == 200) {
       data = jsonDecode(response.body.toString());
      return data;
    } else {
      throw Exception('Error');
    }
  }

}