import 'dart:convert';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';

import 'package:revamp_eperpus_mobile/model/Analytic/DownloadAnalyticModel.dart';
import 'package:revamp_eperpus_mobile/model/Analytic/OpenAppAnalyticModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnalyticService {
  SharedPreferences? sharedPreferences;
  String url = "${ApiClient.instance.baseUrl}analytics";
  var client = http.Client();
  Future<void> openApp({required OpenAppAnalyticModel model}) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences!.getString("JWT");
      var userAgent = sharedPreferences?.getString("userAgent");
      var header = {
        "Authorization": token!,
      };
      var response = await client.post(Uri.parse(url),
          headers: header, body: jsonEncode(model.toJson()));

      if (response.statusCode == 201) {
        await debugLog(response.body);
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        await debugLog(response.body);
        await debugLog(
            "JWT Token signature is invalid, password already changed, login again to get new valid token");
      } else {
        await debugLog(response.body);
      }
    } finally {
      client.close();
    }
  }

  Future<void> downloadItem({required DownloadAnlyticModel model}) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences!.getString("JWT");
      var userAgent = sharedPreferences?.getString("userAgent");
      var header = {
        "Authorization": token!,
      };

      var response = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(model.toJson()));
      if (response.statusCode == 201) {
        await debugLog(response.body);
      } else if (response.statusCode == 403) {
        await debugLog(response.body);
        throw "";
      } else {
        await debugLog(response.body);
        throw "";
      }
    } catch (e) {
      await debugLog("download analytic: $e");
    }
  }

  Future<void> userSearch() async {}

  Future<String> getIpAddress() async {
    var response = await http.get(Uri.parse("https://api.ipify.org"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "192.1.1.24";
    }
  }
}
