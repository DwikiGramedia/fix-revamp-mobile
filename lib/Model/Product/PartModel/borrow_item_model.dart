import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class BorrowItemModel {
  String? href;
  String? title;
  BorrowItemModel({this.href, this.title});
  factory BorrowItemModel.fromJson(Map<String, dynamic> json) {
    return BorrowItemModel(
      href: getJsonValueAsString(json, "href"),
      title: getJsonValueAsString(json, "title"),
    );
  }
  Map<String,dynamic> toJson(){
    return {
      "title":title,
      "href":href
    };
  }
}
