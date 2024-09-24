import 'package:revamp_eperpus_mobile/model/Analytic/OpenAppAnalyticModel.dart';

class DownloadAnlyticModel {
  List<DownloadAnalytic> data;
  DownloadAnlyticModel({required this.data});
  factory DownloadAnlyticModel.fromJson(Map<String, dynamic> json){
    return DownloadAnlyticModel(data: json["downloads"].map<DownloadAnalytic>((e){
      DownloadAnalytic.fromJson(e);
    }).toList() );
  }

  Map<String,dynamic> toJson(){
    return {
      "downloads":data.map((e) => e.toJson()).toList()
    };
  }
}

class DownloadAnalytic  {
  int itemId;
  String downloadStatus;
  String deviceId;
  String deviceModel;
  String clientVersion;
  String clientId;
  String ipAddresss;
  String dateTime;
  int userId;
  String sessionName;
  int catalogId;
  int organizationId;

  DownloadAnalytic(
      {required this.catalogId,
      required this.clientId,
      required this.organizationId,
      required this.userId,
      required this.deviceId,
      required this.itemId,
      required this.clientVersion,
      required this.dateTime,
      required this.deviceModel,
      required this.downloadStatus,
      required this.ipAddresss,
      required this.sessionName});

  factory DownloadAnalytic.fromJson(Map<String, dynamic> json) {
    return DownloadAnalytic(
        catalogId: json["catalog_id"],
        clientId: json["client_id"],
        organizationId: json["organization_id"],
        userId: json["user_id"],
        deviceId: json["device_id"],
        itemId: json["item_id"],
        clientVersion: json["client_version"],
        dateTime: json["datetime"],
        deviceModel: json["device_model"],
        downloadStatus: json["download_status"],
        ipAddresss: json["ip_address"],
        sessionName: json["session_name"]);
  }

  Map<String,dynamic> toJson(){
    return {
      "catalog_id":catalogId,
      "client_id":clientId,
      "organization_id":organizationId,
      "user_id":userId,
      "device_id":deviceId,
      "item_id":itemId,
      "client_version":clientVersion,
      "datetime":dateTime,
      "device_model":deviceModel,
      "download_status":downloadStatus,
      "ip_address":ipAddresss,
      "session_name":sessionName
    };
  }


}


