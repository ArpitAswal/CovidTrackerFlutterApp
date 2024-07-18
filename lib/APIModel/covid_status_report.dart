
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../JsonModel/world_report.dart';
import 'app_url.dart';


class CovidReport {

  Future<WorldCovidStatus> fetchWorldRecords() async {
    final response = await http.get(Uri.parse(AppUrl.WorldAPI));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldCovidStatus.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    List<dynamic> data ;
    final response = await http.get(Uri.parse(AppUrl.CountiesAPI));
    if (response.statusCode == 200) {
       data = jsonDecode(response.body.toString());
      return data;
    } else {
      throw Exception('Error');
    }
  }

}