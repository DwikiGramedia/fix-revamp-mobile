import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const int timeoutSecs = 30;
  static const int timeoutMs = timeoutSecs * 1000;
  final Dio dio;
  static ApiClient? _instance;
  String baseUrl = '';
  int baseOrganizationId = 0;
  int baseCatalogId = 0;
  int clientId = 0;
  String watermark = "";
  String appname = "";
  String userAgent = "";
  String clientAssets = "";
  bool isCustomSplashscren = false;

  factory ApiClient({required FlavorValues values}) {
    final BaseOptions options = BaseOptions(
      receiveTimeout: const Duration(milliseconds: timeoutMs),
      connectTimeout: const Duration(milliseconds: timeoutMs),
    );
    _instance ??= ApiClient._internal(
      Dio(options),
      values.baseUrl!,
      values.baseOrganizationId!,
      values.baseCatalogId!,
      values.clientAssets!,
      values.clientId!,
      values.watermark!,
      values.appConfigName!,
      values.userAgent!,
      values.isCustomSplashscren!,
    );
    return _instance!;
  }
  ApiClient._internal(
      this.dio,
      this.baseUrl,
      this.baseOrganizationId,
      this.baseCatalogId,
      this.clientAssets,
      this.clientId,
      this.watermark,
      this.appname,
      this.userAgent,
      this.isCustomSplashscren);
  static ApiClient get instance => _instance!;

  String? authorization;
  static void setAuth(String auth) {
    _instance!.authorization = auth;
    debugPrint('set Authorization ${_instance!.authorization}');
  }

  String? languageCode;
  static void setLanguageCode(String code) {
    _instance!.languageCode = code;
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> getHeaders() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString("JWT") ?? "";
    final String userAgent = sharedPreferences.getString("userAgent") ?? "";
    Map<String, String>? headers = {
      "Content-Type": "application/json",
    };
    if (token.isNotEmpty) {
      headers.addAll({"User-Agent": userAgent});
    }

    if (userAgent.isNotEmpty) {
      headers.addAll({"Authorization": token});
    }

    return headers;
  }

  void addHeader(String key, dynamic value) {
    headers.addAll({key: value});
  }

  Future<http.Response> getData(
    String endpoint,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(endpoint), headers: headers ?? await getHeaders())
          .timeout(const Duration(seconds: timeoutSecs));
      debugPrint("response $endpoint body: ${response.body}");
      return response;
    } catch (e) {
      if (e is TimeoutException) {
        throw ApiException(
          'Server Timeout',
          uri: Uri.parse(endpoint),
        );
      } else if (e is SocketException) {
        throw ApiException(
          e.message != null && e.message.isNotEmpty
              ? e.message.contains('host lookup')
                  ? 'Koneksi internet mati. Silahkan periksa jaringan internet device.'
                  : e.message
              : e.osError!.message,
          uri: Uri.parse(endpoint),
        );
      }
      rethrow;
    }
  }

  Future<Response<Map<dynamic, dynamic>>> getDataDio(
    String endpoint,
    String data, {
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    final String urlParam = endpoint + data;
    try {
      final response = await dio.get<Map>(
        Uri.encodeFull(urlParam),
        options: Options(headers: headers ?? await getHeaders()),
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw handleException(e, urlParam);
    } catch (e) {
      throw e;
    }
  }

  Future<Response<Map<dynamic, dynamic>>> postData(
      String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      final response = await dio.post<Map>(
        endpoint,
        data: data,
        options: Options(
          headers: headers ?? await getHeaders(),
        ),
      );
      return response;
    } on Exception catch (e) {
      throw handleException(e, endpoint);
    }
  }

  Future<Response<Map<dynamic, dynamic>>> postMultipartData(
      String endpoint, File file) async {
    final Map<String, String> multipartHeaders = await getHeaders();
    multipartHeaders['Content-Type'] = 'multipart/form-data';

    final Map<String, MultipartFile> multipartData = {
      'photo':
          await MultipartFile.fromFile(file.uri.path, filename: 'avatar.jpg'),
    };
    final formData = FormData.fromMap(multipartData);

    return postData(endpoint, formData, headers: multipartHeaders);
  }

  Future<Response<Map<dynamic, dynamic>>> putData(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      final response = await dio.put<Map>(
        endpoint,
        data: data,
        options: Options(
          headers: headers ?? await getHeaders(),
        ),
      );
      return response;
    } on Exception catch (e) {
      throw handleException(e, endpoint);
    }
  }

  Future<Response<Map<dynamic, dynamic>>> deleteData(
      String endpoint, String data,
      {Map<String, String>? headers}) async {
    final String url = endpoint + data;
    try {
      final response = await dio.delete<Map>(
        Uri.encodeFull(url),
        options: Options(headers: headers ?? await getHeaders()),
      );
      return response;
    } on Exception catch (e) {
      throw handleException(e, url);
    }
  }

  Future<Response<dynamic>> unlinkData(
    String endpoint,
    String data, {
    Map<String, String>? headers,
  }) async {
    final String urlParam = endpoint;
    try {
      dio.options.method = "UNLINK";
      if(headers != null){
        dio.options.headers = headers;
      }
      final response = await dio.request(
        Uri.encodeFull(urlParam),
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw handleException(e, urlParam);
    } catch (e) {
      throw e;
    }
  }

  Future<Response<dynamic>> downloadData(
    String url, {
    Map<String, String>? headers,
    String? path,
  }) async {
    try {
      debugPrint("url: ${url}");
      debugPrint("header: ${headers}");
      debugPrint("getHeader: ${await getHeaders()}");
      final response = await dio.get(
        Uri.encodeFull(url),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      debugPrint("Download Data Res: ${response.data}");
      return response;
    } on Exception catch (e) {
      debugPrint("downloadData error: $e");
      throw handleException(e, url);
    }
  }

  Map handleResponse(Response<Map> response, String url) {
    // debugPrint(response.data.toString());
    // debugPrint(response.headers.toString());
    // debugPrint(response.statusCode.toString());
    return response.data!;
  }

  Exception handleException(Exception e, String url) {
    if (e is DioException) {
      print("Dio Exception $url");
      if (e.type == DioExceptionType.badResponse) {
        if (e.response != null) {
          return ApiException(
            e.response!.data.toString(),
            code: e.response!.statusCode,
            uri: Uri.parse(url),
          );
        } else {
          return ApiException(
            e.message!,
            uri: Uri.parse(url),
          );
        }
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        return ApiException(
          e.error.toString(),
          code: e.response!.statusCode,
          isTimeout: true,
          uri: Uri.parse(url),
        );
      } else if (e.message!.contains('host lookup')) {
        return ApiException(
          e.error.toString(),
          code: e.response!.statusCode,
          isInternetActive: false,
          uri: Uri.parse(url),
        );
      } else if (e.type == DioExceptionType.badCertificate) {
        return ApiException(
          e.error.toString(),
          code: e.response!.statusCode,
          isInternetActive: false,
          uri: Uri.parse(url),
        );
      }
      return ApiException(
        e.error.toString(),
        code: e.response!.statusCode,
        uri: Uri.parse(url),
      );
    }
    return e;
  }
}

class ApiException implements Exception {
  ApiException(
    this.message, {
    this.uri,
    this.code,
    this.isTimeout = false,
    this.isInternetActive = true,
  });

  final String message;
  final Uri? uri;
  final int? code;
  final bool? isTimeout;
  final bool? isInternetActive;

  @override
  String toString() {
    final b = StringBuffer()
      ..write('ApiException $code: ')
      ..write(message);
    if (uri != null) {
      b.write(', uri = $uri');
    }

    return b.toString();
  }
}
