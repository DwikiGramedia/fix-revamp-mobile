import 'package:revamp_eperpus_mobile/model/Product/Category/GetCategoryMetaModel.dart';

import 'GetOrganizationNameModel.dart';

class GetCatalogInformationModel {
  int id;
  List<dynamic> items = [];
  String name;
  GetOrganizationNameModel organization;
  GetCategoryMetaModel meta;
  GetCatalogInformationModel(
      {required this.name,
      required this.id,
      required this.items,
      required this.organization,required this.meta});

  factory GetCatalogInformationModel.mapJson(Map<String, dynamic> json) {
    return GetCatalogInformationModel(
        name: json["name"],
        id: json["id"],
        items: json["items"],
        organization: GetOrganizationNameModel.fromJson(json["organization"]), meta: GetCategoryMetaModel.mapJson(json["metadata"]));
  }
}
