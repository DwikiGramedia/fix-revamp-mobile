class PopularBookResponse {
  PopularBookResponse({
    required this.data,
    required this.metadata,
  });

  List<Datum> data;
  Metadata metadata;

  factory PopularBookResponse.fromJson(Map<String, dynamic> json) =>
      PopularBookResponse(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        metadata: Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "metadata": metadata.toJson(),
      };
}

class Datum {
  Datum({
    required this.authors,
    required this.category,
    required this.count,
    required this.itemId,
    required this.itemName,
  });

  String authors;
  dynamic category;
  int count;
  int itemId;
  String itemName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        authors: json["authors"],
        category: json["category"],
        count: json["count"],
        itemId: json["item_id"],
        itemName: json["item_name"],
      );

  Map<String, dynamic> toJson() => {
        "authors": authors,
        "category": category,
        "count": count,
        "item_id": itemId,
        "item_name": itemName,
      };
}

class CategoryElement {
  CategoryElement({
    required
    this.id,
    required
    this.name,
  });

  int id;
  String name;

  factory CategoryElement.fromJson(Map<String, dynamic> json) =>
      CategoryElement(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Metadata {
  Metadata({
    required
    this.resultset,
  });

  Resultset resultset;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        resultset: Resultset.fromJson(json["resultset"]),
      );

  Map<String, dynamic> toJson() => {
        "resultset": resultset.toJson(),
      };
}

class Resultset {
  Resultset({
    required
    this.count,
    required
    this.limit,
    required
    this.offset,
  });

  int count;
  int limit;
  int offset;

  factory Resultset.fromJson(Map<String, dynamic> json) => Resultset(
        count: json["count"],
        limit: json["limit"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "limit": limit,
        "offset": offset,
      };
}
