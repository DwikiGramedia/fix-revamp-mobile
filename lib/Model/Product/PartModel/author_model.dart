import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class AuthorModel {
  int id;
  String href;
  String title;
  AuthorModel({required this.id, required this.title, required this.href});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: getJsonValueAsInt(json, "id"),
      title: getJsonValueAsString(json, "title"),
      href: getJsonValueAsString(json, "href"),
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "href": href, "title": title};
  }
}
