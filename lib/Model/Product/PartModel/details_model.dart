import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class Details {
  int? id;
  String? href;
  String? title;
  Details({this.href, this.title, this.id});

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      id: getJsonValueAsInt(json, 'id'),
      href: getJsonValueAsString(json, 'href'),
      title: getJsonValueAsString(json, 'title'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'href': href, 'title': title};
  }
}
