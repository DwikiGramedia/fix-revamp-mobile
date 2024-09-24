import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

RatingBookAddRes parseBase(Map response) {
  return RatingBookAddRes.fromJson(response as Map<String, dynamic>);
}

class RatingBookAddRes {
  RatingBookAddRes({
    required this.statusCode,
    required this.message,
  });
  final int statusCode;
  final String message;

  factory RatingBookAddRes.fromJson(json) {
    return RatingBookAddRes(
      statusCode: getJsonValueAsInt(json, 'status_code'),
      message: getJsonValueAsString(json, 'message'),
    );
  }

  bool isConflict() {
    return statusCode == 409;
  }

  bool isSuccess() {
    return statusCode == 201;
  }

  bool isError() {
    return statusCode == 400;
  }
}
