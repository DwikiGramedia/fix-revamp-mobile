class OpenAppAnalyticModel {
  List<OpenAppAnalytic> data;

  OpenAppAnalyticModel({required this.data});

  factory OpenAppAnalyticModel.fromJson(Map<String, dynamic> json) {
    return OpenAppAnalyticModel(
        data: json["app_opens"].map<OpenAppAnalytic>((e) {
      return OpenAppAnalytic.fromJson(e);
    }).toList());
  }

  Map<String, dynamic> toJson() {
    return {'app_opens': data.map((e) => e.toJson()).toList()};
  }
}

class OpenAppAnalytic {
  String deviceId;
  String deviceModel;
  String clientVersion;
  int clientId;
  String ipAddresss;
  String dateTime;
  int userId;
  String sessionName;
  int catalogId;
  int organizationId;

  String osVersion;

  OpenAppAnalytic(
      {required this.sessionName,
      required this.ipAddresss,
      required this.deviceModel,
      required this.dateTime,
      required this.clientVersion,
      required this.deviceId,
      required this.userId,
      required this.organizationId,
      required this.clientId,
      required this.catalogId,
      required this.osVersion});

  factory OpenAppAnalytic.fromJson(Map<String, dynamic> json) {
    return OpenAppAnalytic(
        sessionName: json["session_name"] as String,
        ipAddresss: json["ip_address"] as String,
        deviceModel: json["device_model"] as String,
        dateTime: json["datetime"] as String,
        clientVersion: json["client_version"] as String,
        deviceId: json["device_id"] as String,
        userId: json["user_id"] as int,
        organizationId: json["organization_id"] as int,
        clientId: json["client_id"] as int,
        catalogId: json["catalog_id"] as int,
        osVersion: json["os_version"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "session_name": sessionName,
      "ip_address": ipAddresss,
      "datetime": dateTime,
      "client_version": clientVersion,
      "device_id": deviceId,
      "user_id": userId,
      "organization_id": organizationId,
      "client_id": clientId,
      "catalog_id": catalogId,
      "os_version": osVersion
    };
  }
}
