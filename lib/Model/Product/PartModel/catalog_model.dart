import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class Catalog {
  String? href;
  int? id;
  int? count;
  String? rel;
  String? title;
  Catalog({
    this.id,
    this.count,
    this.title,
    this.href,
    this.rel,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      id: getJsonValueAsInt(json, "id"),
      count: getJsonValueAsInt(json, "count"),
      title: getJsonValueAsString(json, "title"),
      href: getJsonValueAsString(json, "href"),
      rel: getJsonValueAsString(json, "rel"),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'count': count, 'title': title, 'href': href, 'rel': rel};
  }
}

class Catalogs {
  String? href;
  int? count;
  String? title;

  Catalogs({
    this.count,
    this.title,
    this.href,
  });

  factory Catalogs.fromJson(Map<String, dynamic> json) {
    return Catalogs(
      count: getJsonValueAsInt(json, "count"),
      title: getJsonValueAsString(json, "title"),
      href: getJsonValueAsString(json, "href"),
    );
  }

  Map<String, dynamic> toJson() {
    return {'count': count, 'title': title, 'href': href};
  }
}
