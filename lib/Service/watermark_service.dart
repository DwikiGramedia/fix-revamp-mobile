import 'dart:convert';

import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Watermark/WatermarkResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WatermarkService {
  var client = http.Client();
  Future<WatermarkResponse> getWatermark() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("JWT");
    var organizationId = sharedPreferences.getInt("organizationId");
    var userAgent = sharedPreferences.getString("userAgent");

    var header = {'Authorization': token!, "User-Agent": userAgent!};
    var urlString =
        "${ApiClient.instance.baseUrl}items/watermark/code?organization_id=${organizationId ?? ApiClient.instance.baseOrganizationId}";
    await debugLog(urlString);
    try {
      var response =
          await ApiClient.instance.getDataDio(urlString, '');
      await debugLog(response.data.toString());
      if (response.statusCode == 200) {
        WatermarkResponse data = WatermarkResponse.fromJson(response.data);
        return data;
      } else {
        throw "watermarkApi(): Error dalam pencarian";
      }
    } finally {}
  }
}
