class GetOrganizationNameModel{
  String href;
  int id;
  String name;
  GetOrganizationNameModel({required this.id,required this.href,required this.name});

  factory GetOrganizationNameModel.fromJson(Map<String,dynamic> json){
    return GetOrganizationNameModel(id: json["id"], href: json["href"], name: json["name"]);
  }
}