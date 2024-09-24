import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class OpenRegistrationRes {
  OpenRegistration? openregis;
  String? error;
  int? statusCode;

  OpenRegistrationRes({
    required this.openregis,
    required this.error,
    required this.statusCode,
});

  factory OpenRegistrationRes.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? data = getJsonValueAsJson(json, "data");
    Map<String, dynamic>? features = getJsonValueAsJson(data, "features");

    return OpenRegistrationRes(
      openregis: OpenRegistration.fromJson(getJsonValueAsJson(features, "openregis")),
      error: getJsonValueAsString(json, "error"),
      statusCode: getJsonValueAsInt(json, "status_code"),
    );
  }
}

class OpenRegistration {
  int? id;
  bool isOpenRegis;
  String? openRegisStartDate;
  String? openRegisStopDate;
  bool isActive;

  OpenRegistration({
    required this.id,
    required this.isOpenRegis,
    required this.openRegisStartDate,
    required this.openRegisStopDate,
    required this.isActive,
  });

  factory OpenRegistration.fromJson(Map<String, dynamic> json) {
    return OpenRegistration(
      id: getJsonValueAsInt(json, "id"),
      isOpenRegis: getJsonValueAsBool(json, "is_openregis"),
      openRegisStartDate: getJsonValueAsString(json, "openregis_start_date"),
      openRegisStopDate: getJsonValueAsString(json, "openregis_end_date"),
      isActive: getJsonValueAsBool(json, "is_active"),
    );
  }
}
