bool isDataNotNull(Map<dynamic, dynamic>? json, String key) {
  return json != null && json.containsKey(key) && json[key] != null;
}

dynamic getJsonValue(Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key) ? json![key] : null;
}

Map<String, dynamic> getJsonValueAsJson(
    Map<dynamic, dynamic>? json, String key) {
  dynamic value = getJsonValue(json, key);
  return value == null ? {} : value as Map<String, dynamic>;
}

List<Map<String, dynamic>> getJsonListValue(
    Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key)
      ? json![key].cast<Map<String, dynamic>>()
      : <Map<String, dynamic>>[];
}

String getJsonValueAsString(Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key) ? json![key].toString() : '';
}

int getJsonValueAsInt(Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key) ? json![key].toInt() : 0;
}

bool getJsonValueAsBool(Map<dynamic, dynamic>? json, String key) {
  if (getJsonValue(json, key) is bool) {
    return getJsonValue(json, key) as bool;
  }
  return getJsonValueAsString(json, key) == '1';
}

double getJsonValueAsDouble(Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key) ? json![key].toDouble() : 0.0;
}

List<String> getJsonValueAsStringList(Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key) ? List<String>.from(json![key]) : [];
}

List<int> getJsonValueAsIntList(Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key) ? List<int>.from(json![key]) : [];
}

DateTime? getJsonValueAsDateTime(Map<dynamic, dynamic>? json, String key) {
  return isDataNotNull(json, key) ? DateTime.parse(json![key]) : null;
}
