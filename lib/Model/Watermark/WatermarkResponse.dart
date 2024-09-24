class WatermarkResponse {
  WatermarkResponse({
    required this.appName,
    required this.applicationId,
    required this.code,
    required this.id,
    required this.isActive,
    required this.organizationId,
  });

  String appName;
  int applicationId;
  String code;
  int id;
  bool isActive;
  int organizationId;

  factory WatermarkResponse.fromJson(json) => WatermarkResponse(
        appName: json["app_name"],
        applicationId: json["application_id"],
        code: json["code"],
        id: json["id"],
        isActive: json["is_active"],
        organizationId: json["organization_id"],
      );

  Map<String, dynamic> toJson() => {
        "app_name": appName,
        "application_id": applicationId,
        "code": code,
        "id": id,
        "is_active": isActive,
        "organization_id": organizationId,
      };
}
