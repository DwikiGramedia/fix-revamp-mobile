import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class CoverImage {
  String? href;
  String? title;
  CoverImage({this.title, this.href});

  CoverImage.fromJson(Map<String, dynamic> json) {
    href = getJsonValueAsString(json, 'href');
    title = getJsonValueAsString(json, 'title');
  }
  Map<String,dynamic> toJson(){
    return {
      "title":title,
      "href":href
    };
  }
}
