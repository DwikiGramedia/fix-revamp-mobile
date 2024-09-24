class UniqueModel {
  String device_imei;
  String device_mid;
  String device_model;
  String unique_id;

  UniqueModel(
      {required this.device_imei,
      required this.device_mid,
      required this.device_model,
      required this.unique_id});

  factory UniqueModel.fromJson(Map<String, dynamic> json) {
    return UniqueModel(
        device_imei: json["device_imei"],
        device_mid: json["device_mid"],
        device_model: json["device_model"],
        unique_id: json["unique_id"]);
  }
}
