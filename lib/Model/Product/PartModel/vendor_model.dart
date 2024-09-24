import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class Vendor {
  String? href;
  String? title;
  Vendor({required this.title, required this.href});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      title: getJsonValueAsString(json, "title"),
      href: getJsonValueAsString(json, "href"),
    );
  }
  Map<String, dynamic> toJson() {
    return {'href': href, 'title': title};
  }
}
