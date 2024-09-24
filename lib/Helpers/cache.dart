import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<T> getPref<T>(String prefKey, T defaultValue) async {
  final prefs = await SharedPreferences.getInstance();
  dynamic prefValue;
  if (defaultValue is bool) {
    prefValue = prefs.getBool(prefKey) ?? defaultValue;
  } else if (defaultValue is double) {
    prefValue = prefs.getDouble(prefKey) ?? defaultValue;
  } else if (defaultValue is int) {
    prefValue = prefs.getInt(prefKey) ?? defaultValue;
  } else if (defaultValue is String) {
    prefValue = prefs.getString(prefKey) ?? defaultValue;
  } else if (defaultValue is List<String>) {
    prefValue = prefs.getStringList(prefKey) ?? defaultValue;
  } else if (defaultValue is Map<String, dynamic>) {
    prefValue = jsonDecode(prefs.getString(prefKey)!) ?? defaultValue;
  } else {
    prefValue = prefs.get(prefKey) ?? defaultValue;
  }
  return prefValue;
}

Future<void> savePref<T>(String prefKey, T value) async {
  final prefs = await SharedPreferences.getInstance();
  if (value is bool) {
    await prefs.setBool(prefKey, value);
  } else if (value is double) {
    await prefs.setDouble(prefKey, value);
  } else if (value is int) {
    await prefs.setInt(prefKey, value);
  } else if (value is String) {
    await prefs.setString(prefKey, value);
  } else if (value is List<String>) {
    await prefs.setStringList(prefKey, value);
  } else if (value is Map<String, dynamic>) {
    await prefs.setString(prefKey, jsonEncode(value));
  } else {
    throw 'savePref: $value is not defined';
  }
}

Future<void> removePref(String prefKey) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(prefKey);
}

Future<void> debugLog(String logMessage) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var buildName = packageInfo.version;
  var message = "[${ApiClient.instance.appname} - $buildName] : $logMessage";

  if (kDebugMode) {
    debugPrint(message);
  }
}

const savedLoginInfo = 'LOGIN_INFO';

Future<void> setLoginInfo(Map<String, dynamic> info) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String infoAsString = json.encode(info);
  prefs.setString(savedLoginInfo, infoAsString);
}

Future<String?> getLoginInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(savedLoginInfo);
}

Future<bool?> deleteLoginInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove(savedLoginInfo);
}

const showCaseHome = 'show_case_home';
Future<void> setShowCaseHome(bool value) async {
  debugPrint('setShowCaseHome: $value');
  await savePref(showCaseHome, value);
}

Future<bool?> getShowCaseHome() async {
  bool value = await getPref(showCaseHome, true);
  return value;
}

Future<void> deleteShowCaseHome() async {
  debugPrint('removeToken');
  await removePref(showCaseHome);
}

const showCaseCollection = 'show_case_collection';
Future<void> setShowCaseCollection(bool value) async {
  debugPrint('setShowCaseCollection: $value');
  await savePref(showCaseCollection, value);
}

Future<bool?> getShowCaseCollection() async {
  bool value = await getPref(showCaseCollection, true);
  return value;
}

Future<void> deleteShowCaseCollection() async {
  debugPrint('removeToken');
  await removePref(showCaseCollection);
}

const showCaseDevice = 'show_case_device';
Future<void> setShowCaseDevice(bool value) async {
  debugPrint('setShowCaseDevice: $value');
  await savePref(showCaseDevice, value);
}

Future<bool?> getShowCaseDevice() async {
  bool value = await getPref(showCaseDevice, true);
  return value;
}

Future<void> deleteShowCaseDevice() async {
  debugPrint('removeToken');
  await removePref(showCaseDevice);
}

const showCaseProfile = 'show_case_profile';
Future<void> setShowCaseProfile(bool value) async {
  debugPrint('setShowCaseProfile: $value');
  await savePref(showCaseProfile, value);
}

Future<bool?> getShowCaseProfile() async {
  bool value = await getPref(showCaseProfile, true);
  return value;
}

Future<void> deleteShowCaseProfile() async {
  debugPrint('removeToken');
  await removePref(showCaseProfile);
}

const userProfileData = 'user_profile_data';
Future<void> setUserProfileData(String value) async {
  debugPrint('setUserProfileData: $value');
  await savePref(userProfileData, value);
}

Future<String?> getUserProfileData() async {
  String? value = await getPref(userProfileData, '');
  return value;
}

Future<void> deleteUserProfileData() async {
  debugPrint('deleteUserProfileData');
  await removePref(userProfileData);
}

const watermark = 'watermark';
Future<void> setWatermark(String value) async {
  debugPrint('setWatermark: $value');
  await savePref(watermark, value);
}

Future<String?> getWatermark() async {
  String? value = await getPref(watermark, '');
  return value;
}

Future<void> deleteWatermark() async {
  debugPrint('deleteWatermark');
  await removePref(watermark);
}

const firebaseToken = 'firebaseToken';
Future<void> setFirebaseToken(String value) async {
  debugPrint('setFirebaseToken: $value');
  await savePref(firebaseToken, value);
}

Future<String?> getFirebaseToken() async {
  debugPrint('getFirebaseToken');
  String? value = await getPref(firebaseToken, '');
  return value;
}

Future<void> deleteFirebaseToken() async {
  debugPrint('deleteFirebaseToken');
  await removePref(firebaseToken);
}

const sessionName = 'sessionName';
Future<void> setSessionName(String value) async {
  debugPrint('setSessionName: $value');
  await savePref(sessionName, value);
}

Future<String?> getSessionName() async {
  debugPrint('getSessionName');
  String? value = await getPref(sessionName, '');
  return value;
}

Future<void> deleteSessionName() async {
  debugPrint('deleteSessionName');
  await removePref(sessionName);
}

const pointerAbsorb = 'pointerAbsorb';
Future<void> setPointerAbsorb(bool value) async {
  debugPrint('setPointerAbsorb: $value');
  await savePref(pointerAbsorb, value);
}

Future<bool?> getPointerAbsorb() async {
  debugPrint('getPointerAbsorb');
  bool? value = await getPref(pointerAbsorb, false);
  return value;
}

Future<void> deletePointerAbsorb() async {
  debugPrint('deletePointerAbsorb');
  await removePref(pointerAbsorb);
}

const primaryCatalog = 'primaryCatalog';
Future<void> setPrimaryCatalog(int value) async {
  debugPrint('setPrimaryCatalog: $value');
  await savePref(primaryCatalog, value);
}

Future<int?> getPrimaryCatalog() async {
  debugPrint('getPrimaryCatalog');
  int? value = await getPref(primaryCatalog, ApiClient.instance.baseCatalogId);
  return value;
}

Future<void> deletePrimaryCatalog() async {
  debugPrint('deletePrimaryCatalog');
  await removePref(primaryCatalog);
}

const orgUrl = 'orgUrl';
Future<void> setOrgUrl(String value) async {
  debugPrint('setOrgUrl: $value');
  await savePref(orgUrl, value);
}

Future<String?> getOrgUrl() async {
  debugPrint('getOrgUrl');
  String? value = await getPref(orgUrl, "");
  return value;
}

Future<void> deleteOrgUrl() async {
  debugPrint('deleteOrgUrl');
  await removePref(orgUrl);
}

const searchHistory = 'searchHistory';
Future<void> setSearchHistory(List<String> value) async {
  debugPrint('setSearchHistory: $value');
  await savePref(searchHistory, value);
}

Future<List<String>> getSearchHistory() async {
  debugPrint('getSearchHistory');
  List<String> value = await getPref(searchHistory, []);
  return value;
}

Future<void> deleteSearchHistory() async {
  debugPrint('deleteSearchHistory');
  await removePref(searchHistory);
}

const sortText = 'sortText';
Future<void> setSortText(String value) async {
  // debugPrint('setSortText: $value');
  await debugLog('setSortText: $value');
  await savePref(sortText, value);
}

Future<String> getSortText() async {
  debugPrint('getSortText');
  String value = await getPref(sortText, "Sort By");
  return value;
}

Future<void> deleteSortText() async {
  debugPrint('deleteSortText');
  await removePref(sortText);
}

const isOpenRegis = 'isOpenRegis';
Future<void> setIsOpenRegis(bool value) async {
  // debugPrint('setSortText: $value');
  await debugLog('setIsOpenRegis: $value');
  await savePref(isOpenRegis, value);
}

Future<bool> getIsOpenRegis() async {
  debugPrint('getIsOpenRegis');
  bool value = await getPref(isOpenRegis, false);
  return value;
}

Future<void> deleteIsOpenRegis() async {
  debugPrint('deleteIsOpenRegis');
  await removePref(isOpenRegis);
}
