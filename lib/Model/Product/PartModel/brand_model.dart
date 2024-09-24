import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class BrandModel {
  int id;
  String name;
  BrandModel({required this.id, required this.name});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: getJsonValueAsInt(json, "id"),
      name: getJsonValueAsString(json, "name"),
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }
}
