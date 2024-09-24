import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class GetCategoryMetaModel {
  List<Facets> facets;
  ResultSet resultset;
  List<dynamic> spelling_suggestions = [];
  GetCategoryMetaModel(
      {required this.facets,
      required this.resultset});
  
  factory GetCategoryMetaModel.mapJson(Map<String,dynamic>  json){
    return GetCategoryMetaModel(facets: json["facets"]
        .map<Facets>((item) => Facets.mapJson(item))
        .toList(), resultset: ResultSet.mapJson(json["resultset"]));
  }
}

class ResultSet {
  int count;
  int limit;
  int offset;
  ResultSet({required this.count, required this.limit, required this.offset});

  factory ResultSet.mapJson(Map<String, dynamic> json) {
    return ResultSet(
        count: json["count"], limit: json["limit"], offset: json["offset"]);
  }
}

class Facets {
  String field_name;
  List<ItemValueFacets> values;
  Facets({required this.field_name, required this.values});

  factory Facets.mapJson(Map<String, dynamic> json) {
    return Facets(
        field_name: json["field_name"],
        values: json["values"]
            .map<ItemValueFacets>((item) => ItemValueFacets.mapJson(item))
            .toList());
  }
}

class ItemValueFacets {
  int count;
  String value;
  ItemValueFacets({required this.count, required this.value});

  factory ItemValueFacets.mapJson(Map<String, dynamic> json) {
    return ItemValueFacets(count: json["count"], value: json["value"]);
  }
}
