import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:revamp_eperpus_mobile/Helpers/api_constant.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Product/product_model.dart';
import 'package:revamp_eperpus_mobile/model/UniqueId/unique_model.dart';
import 'package:revamp_eperpus_mobile/model/User/user_model.dart';
import 'package:revamp_eperpus_mobile/model/organization_data.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  String basicUrl = ApiClient.instance.baseUrl;
  SharedPreferences? sharedPreferences;
  var client = http.Client();

  Future<void> setLocale(Locale locale) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences?.setString("codeLanguage", locale.languageCode);
    AppLocalizations.delegate.load(locale);
  }

  Future<UserLoginResponse> login({
    required String username,
    required String password,
    required String deviceId,
    required String clientId,
    required String modelDevice,
    required String osVersion,
    required String uniqueId,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var buildName = packageInfo.version;
    var buildNumber = packageInfo.buildNumber;

    sharedPreferences?.setString(
        "userAgent", "${ApiClient.instance.userAgent}/$buildName");
    sharedPreferences?.setString("buildName", buildName);
    sharedPreferences?.setString("buildNumber", buildNumber);

    var userAgent = sharedPreferences!.getString("userAgent");

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Client_Id": clientId,
      "Device-Model": modelDevice,
      "Os-Version": osVersion,
      'User-Agent': userAgent!,
      "Accept": "application/vnd.scoop.v3+json"
    };

    List<int> passwordBytes = utf8.encode("5gvi-ojhgf%^&YGBNeds1{$password");
    String passwordDigest = sha1.convert(passwordBytes).toString();
    var body = jsonEncode({
      "password": password,
      "username": username,
    });

    print("Header: $headers");
    print("Body: $body");

    var url = Uri.parse("${ApiClient.instance.baseUrl}auth/login");

    print("URL: $url");

    try {
      var response = await client.post(url, headers: headers, body: body);
      print("LOGIN RESPONSE: ${response.body}");
      if (response.statusCode == 200) {
        UserLoginResponse user =
            UserLoginResponse.fromJson(jsonDecode(response.body));
        user.token = "JWT ${user.token}";
        sharedPreferences?.setString("JWT", user.token);
        sharedPreferences?.setInt("user_id", user.id ?? 0);
        sharedPreferences?.setString("email", user.email ?? "");
        // sharedPreferences?.setString("userAgent", "eperpus bca ${Platform.isIOS ? "ios" : "android"}/2.8.0");
        sharedPreferences?.setString("modelDevice", modelDevice);
        sharedPreferences?.setString("clientId", clientId);
        sharedPreferences?.setString("osVersion", osVersion);
        ApiClient.setAuth(user.token);
        await UserService().sendNotificationKey();
        return user;
      } else {
        if (jsonDecode(response.body)["user_message"] ==
            "You have reached maximum number of authorized devices."
                "\nPlease deauthorized first then re-login") {
          throw "${jsonDecode(response.body)["user_message"]}";
        } else {
          throw "${jsonDecode(response.body)["user_message"]}";
        }
      }
    } finally {
      client.close();
    }
  }

  Future<UniqueModel> sendDevice({
    required String deviceImei,
    required String deviceMid,
    required String deviceModel,
  }) async {
    var url = Uri.parse("${ApiClient.instance.baseUrl}auth/device");
    var data = jsonEncode({
      "device_imei": deviceImei,
      "device_mid": deviceMid,
      "device_model": deviceModel
    });
    var response = await http.post(url, body: data);
    if (response.statusCode == 201) {
      UniqueModel uniqueModel = UniqueModel.fromJson(jsonDecode(response.body));
      return uniqueModel;
    } else {
      throw "${response.statusCode} ${response.body}";
    }
  }

  Future<int> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT")!;
    var userAgent = sharedPreferences!.getString("userAgent");
    var url = Uri.parse("${ApiClient.instance.baseUrl}auth/change-password");
    var header = {
      "Content-Type": "application/json",
      'Authorization': token,
      // "User-Agent": ApiClient.instance.userAgent
      "User-Agent": userAgent!
    };
    List<int> passwordBytesNew =
        utf8.encode("5gvi-ojhgf%^&YGBNeds1{$newPassword");
    String passwordDigestNew = sha1.convert(passwordBytesNew).toString();
    List<int> passwordBytesOld =
        utf8.encode("5gvi-ojhgf%^&YGBNeds1{$currentPassword");
    String passwordDigestOld = sha1.convert(passwordBytesOld).toString();

    var body = jsonEncode(
        {"new_password": passwordDigestNew, "password": passwordDigestOld});

    var response = await http.put(url, headers: header, body: body);
    if (response.statusCode == 204) {
      return response.statusCode;
    } else {
      throw "Error Change Password with :${jsonDecode(response.body)['user_message']}";
    }
  }

  Future<String> deauthorize({
    required String username,
    required String password,
    required String modelDevice,
    required String osVersion,
  }) async {
    try{
      var url = Uri.parse('${basicUrl}auth/deauthorize-all');

      sharedPreferences = await SharedPreferences.getInstance();
      var userAgent = sharedPreferences!.getString("userAgent");

      var header = {
        'Client_Id': '${ApiClient.instance.clientId}',
        "Device-Model": modelDevice,
        "Os-Version": osVersion,
        // 'User-Agent': ApiClient.instance.userAgent,
        'User-Agent': userAgent!,
        "Accept": "application/vnd.scoop.v3+json"
      };

      List<int> passwordBytes = utf8.encode("5gvi-ojhgf%^&YGBNeds1{$password");
      String passwordDigest = sha1.convert(passwordBytes).toString();

      var body = jsonEncode({"username": username, "password": password});
      var response = await http.post(url, headers: header, body: body);
      print("Response Deauth: ${response.body} ");
      if (response.statusCode == 200) {
        return "Success Reauthorize, please login again";
      } else {
        throw Exception('Error Reauthorize, please check email / password');
      }
    }catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> logout() async {
    await UserService().deleteNotificationKey();
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences?.remove('JWT');
    sharedPreferences?.remove("user_id");
    sharedPreferences?.remove("email");
    // sharedPreferences?.remove("userAgent");
    sharedPreferences?.remove("modelDevice");
    sharedPreferences?.remove("clientId");
    sharedPreferences?.remove("osVersion");
    deleteFirebaseToken();
  }

  Future<List<HistoryBorrowProductModel>> getBorrowBookCurrentUser(
    DateTime date,
    int offset,
    int limit,
  ) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT")!;
    var userAgent = sharedPreferences!.getString("userAgent");

    var url = Uri.parse(
      '${ApiClient.instance.baseUrl}users/current-user/borrowed-items-history?offset=$offset&limit=$limit&order=${date.day}/${date.month}/${date.year}',
    );
    var response = await http.get(url, headers: {
      'Authorization': token,
      // "User-Agent": ApiClient.instance.userAgent
      "User-Agent": userAgent!
    });

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['items'];
      List<HistoryBorrowProductModel> models = [];
      for (var item in data) {
        models.add(HistoryBorrowProductModel.fromJson(item));
      }

      //ListProductModel model = ListProductModel.fromJson(json);
      return models;
    } else {
      throw Exception("${jsonDecode(response.body)['user_message']}");
    }
  }

  Future<List<HistoryBorrowProductModel>> searchBorrowingHistory(
      String search) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT")!;
    var userAgent = sharedPreferences!.getString("userAgent");
    String queryEncode = Uri.encodeComponent(search);

    var url = Uri.parse(
      '${ApiClient.instance.baseUrl}users/current-user/borrowed-items-history?q=$queryEncode&offset=0&limit=20',
    );
    var response = await http.get(url, headers: {
      'Authorization': token,
      // "User-Agent": ApiClient.instance.userAgent
      "User-Agent": userAgent!
    });

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['items'];
      List<HistoryBorrowProductModel> models = [];
      for (var item in data) {
        models.add(HistoryBorrowProductModel.fromJson(item));
      }

      //ListProductModel model = ListProductModel.fromJson(json);
      return models;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw "Force logout";
    } else {
      throw Exception("${jsonDecode(response.body)['user_message']}");
    }
  }

  Future<GetDataUserResponse> getDataUser({BuildContext? context}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences?.getInt("user_id");
    try {
      var response = await ApiClient.instance
          .getDataDio("${ApiClient.instance.baseUrl}users/$id", '');
      if (response.statusCode == 200) {
        var dataUser = GetDataUserResponse.fromJson(response.data);
        print("DATA USER ID: ${dataUser.id}");
        return dataUser;
      } else if (response.statusCode == 401) {
        throw "Force logout";
      } else if (response.statusCode == 400) {
        throw response.statusCode!;
      } else {
        await debugLog(response.data.toString());
        throw "Error get data user";
      }
    } catch (e) {
      ApiException err = e as ApiException;
      throw err;
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> addUserAccount({
    required BuildContext context,
    required String username,
    required String birthdate,
    required int gender,
    required String email,
    required String password,
    required String deviceModel,
    required String oSVersion,
    String? password2,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final localization = AppLocalizations.of(context)!;
      sharedPreferences = await SharedPreferences.getInstance();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      var buildName = packageInfo.version;

      var newUrl = Uri.parse("${ApiClient.instance.baseUrl}users");
      var userAgent = sharedPreferences!.getString("userAgent") ??
          "${ApiClient.instance.userAgent}/$buildName";
      List<int> passwordBytes = utf8.encode("5gvi-ojhgf%^&YGBNeds1{$password");
      String passwordDigest = sha1.convert(passwordBytes).toString();
      final String prefix = FlavorConfig.instance.values.openRegisPrefix;
      final int clientId = FlavorConfig.instance.values.clientId!;
      final String newBody = jsonEncode({
        "password": passwordDigest,
        "allow_age_restricted_content": true,
        "last_name": lastName,
        "username": "$prefix$username",
        "email": email,
        "origin_client_id": "${ApiClient.instance.clientId}",
        "profile": {
          "origin_device_model": deviceModel,
          "gender": "$gender",
          "birthdate": birthdate
        },
        "first_name": firstName
      });

      final Map<String, String> header = {
        "Content-Type": "application/json",
        "User-Agent": userAgent,
        "client-id": "$clientId"
      };

      var response = await http.post(newUrl, headers: header, body: newBody);
      if (response.statusCode == 204 || response.statusCode == 201) {
        final Map<String, dynamic> resAsMap = {
          "status": response.statusCode,
          "message": localization.registerSuccess,
        };
        return resAsMap;
      } else {
        final Map<String, dynamic> resAsMap = {
          "status": response.statusCode,
          "message": "${jsonDecode(response.body)['user_message']}",
        };
        return resAsMap;
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception(e);
    }
  }

  Future<OrganizationUser?> getOrganizationData({
    required int userId,
  }) async {
    try {
      String endpoint =
          "${ApiClient.instance.baseUrl}/organizations/${ApiClient.instance.baseOrganizationId}";
      final response = await ApiClient.instance.getDataDio(endpoint, '');
      if (response.data!['status'] != 404) {
        return OrganizationUser.fromJson(response.data);
      } else {
        return OrganizationUser();
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<String> resetPassword({
    required BuildContext context,
    required String username,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();

    var uri = Uri.parse("${ApiClient.instance.baseUrl}auth/reset-password");
    sharedPreferences = await SharedPreferences.getInstance();
    var userAgent = sharedPreferences!.getString("userAgent");

    final String body = jsonEncode({"username": username});

    final Map<String, String> header = {
      "Content-Type": "application/json",
      "Accept": "application/vnd.scoop.v3+json",
      "Client-Id": "${ApiClient.instance.clientId}",
      "User-Agent": userAgent!,
    };

    var response = await http.post(uri, headers: header, body: body);
    final resJson = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AppLocalizations.of(context)!.forgotPasswordSuccess;
    } else if (response.statusCode == 403) {
      return resJson["user_message"];
    } else {
      throw Exception(
        "Error with :${jsonDecode(response.body)['user_message']}",
      );
    }
  }

  Future<String> patchResendVerification({
    required BuildContext context,
    required String email,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();

    var uri =
        Uri.parse("${ApiClient.instance.baseUrl}auth/resend-verification");
    sharedPreferences = await SharedPreferences.getInstance();
    var userAgent = sharedPreferences!.getString("userAgent");

    final String body = jsonEncode({"email": email});

    final Map<String, String> header = {
      "Content-Type": "application/json",
      "User-Agent": userAgent!
    };

    var response = await http.patch(uri, headers: header, body: body);
    if (response.statusCode == 200 || response.statusCode == 204) {
      debugPrint("Status Code ${response.statusCode}");
      return response.statusCode.toString();
    } else {
      print(
        "Error with :${jsonDecode(response.body)}",
      );
      throw Exception(
        "Error with :${jsonDecode(response.body)['user_message']}",
      );
    }
  }

  Future<String> deleteAccount({
    required int userId,
    required int organizationId,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences!.getString("JWT")!;
    final userAgent = sharedPreferences!.getString("userAgent");
    var url =
        "${ApiClient.instance.baseUrl}organizations/$organizationId/users";

    var header = {
      "Content-Type": "application/json",
      "Accept": "application/vnd.scoop.v3+json",
      "Client-Id": "${ApiClient.instance.clientId}",
      "User-Agent": userAgent!,
      "Authorization": token
    };

    var body = jsonEncode({"id": userId.toString()});

    Dio dio = Dio();
    dio.options.method = "UNLINK";
    dio.options.headers = header;
    Response response = await dio.request(url, data: body);
    if (response.statusCode == 200) {
      return "Success Delete Account :${response.data}";
    } else {
      throw "Error Delete Account :${response.data}";
    }
  }

  Future<dynamic> getOpenRegistration() async {
    try {
      final int clientId = ApiClient.instance.clientId;
      final String url =
          "${ApiClient.instance.baseUrl == ApiConstant.scoopCoreAPI ? ApiConstant.revampProdAPI : ApiConstant.revampStagingAPI}saas/organization/$clientId";
      print("open regis url: $url");
      final response = await http.get(Uri.parse(url));
      print("Get Open Regis: ${response.body}");
      final dynamic result = jsonDecode(response.body);
      return result;
    } catch (e) {
      print("getOpenRegistration Exception: $e");
      throw e;
    }
  }

  Future<dynamic> getUserQuotaStatus() async {
    try {
      final int clientId = ApiClient.instance.clientId;
      final String url =
          "${ApiConstant.revampProdAPI}saas/organization/$clientId";
      final response = await http.get(Uri.parse(url));
      final dynamic result = jsonDecode(response.body);
      return result;
    } catch (e) {
      print("getOpenRegistration Exception: $e");
      throw e;
    }
  }

  Future<void> sendNotificationKey() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? fcmToken = await getFirebaseToken();
    String? jwtToken = sharedPreferences?.getString("JWT") ?? "";
    String? userAgent = sharedPreferences?.getString("userAgent") ?? "";
    var body = jsonEncode({"device_register_key": fcmToken ?? ""});
    print("Value token firebase \($body)");
    print("Token JWT \($jwtToken)");
    if (jwtToken.isNotEmpty) {
      try {
        var response = await client.post(
          Uri.parse(
              "${ApiClient.instance.baseUrl}users/current-user/notification"),
          headers: {
            "Authorization": jwtToken,
            "User-Agent": userAgent,
          },
          body: body,
        );

        debugPrint("Firebase Send Key ${response.body}");
        if (response.statusCode == 200) {
          debugPrint(response.statusCode.toString());
        } else if (response.statusCode == 401) {}
      } catch (e) {
        debugPrint("Firebase Send Key Error: ${e.toString()}");
      }
    }
  }

  Future<void> putNotificationKey() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? fcmToken = await getFirebaseToken();
    String? jwtToken = sharedPreferences?.getString("JWT") ?? "";
    String? userAgent = sharedPreferences?.getString("userAgent") ?? "";
    var body = jsonEncode({"device_register_key": fcmToken ?? ""});
    if (jwtToken.isNotEmpty) {
      try {
        var response = await client.put(
          Uri.parse(
              "${ApiClient.instance.baseUrl}users/current-user/notification"),
          headers: {
            "Authorization": jwtToken,
            "User-Agent": userAgent,
          },
          body: body,
        );

        debugPrint("Firebase Put Key${response.body}");
        if (response.statusCode == 200) {
          debugPrint(response.statusCode.toString());
        } else if (response.statusCode == 401) {}
      } catch (e) {
        debugPrint("Firebase Put Key Error: ${e.toString()}");
      }
    }
  }

  Future<void> deleteNotificationKey() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? fcmToken = await getFirebaseToken();
    String? jwtToken = sharedPreferences?.getString("JWT") ?? "";
    String? userAgent = sharedPreferences?.getString("userAgent") ?? "";
    print("Token JWT \($jwtToken)");
    if (jwtToken.isNotEmpty) {
      try {
        var response = await client.delete(
          Uri.parse(
              "${ApiClient.instance.baseUrl}users/current-user/notification/$fcmToken"),
          headers: {
            "Authorization": jwtToken,
            "User-Agent": userAgent,
          },
        );

        debugPrint("Send message${response.body}");
        if (response.statusCode == 200) {
          debugPrint(response.statusCode.toString());
        } else if (response.statusCode == 401) {}
      } catch (e) {
        debugPrint("Firebase Delete Key Error: ${e.toString()}");
      }
    }
  }
}
