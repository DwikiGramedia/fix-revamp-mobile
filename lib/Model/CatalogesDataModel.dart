import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class CatalogesDataModel {
  CatalogesDataModel({
    required this.catalogs,
  });

  List<CatalogData> catalogs;

  factory CatalogesDataModel.fromJson(json) {
    return CatalogesDataModel(
      catalogs: getJsonListValue(json, 'catalogs')
          .map<CatalogData>((dynamic value) => CatalogData.fromJson(value))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "catalogs": List<dynamic>.from(catalogs.map((x) => x.toJson())),
      };
}

class CatalogData {
  CatalogData({
    this.href,
    this.id,
    this.isInternalCatalog,
//    this.sharedLibrary,
    this.title,
  });

  String? href;
  int? id;
  bool? isInternalCatalog;
//  SharedLibrary? sharedLibrary;
  String? title;

  factory CatalogData.fromJson(Map<String, dynamic> json) => CatalogData(
        href: json["href"],
        id: json["id"],
        isInternalCatalog: json["is_internal_catalog"],
//    sharedLibrary: SharedLibrary.fromJson(json["shared_library"]),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "id": id,
        "is_internal_catalog": isInternalCatalog,
//    "shared_library": sharedLibrary?.toJson(),
        "title": title,
      };
}

class SharedLibrary {
  SharedLibrary({
    this.href,
    this.id,
    this.title,
  });

  String? href;
  int? id;
  String? title;

  factory SharedLibrary.fromJson(Map<String, dynamic> json) => SharedLibrary(
        href: json["href"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
        "id": id,
        "title": title,
      };
}
