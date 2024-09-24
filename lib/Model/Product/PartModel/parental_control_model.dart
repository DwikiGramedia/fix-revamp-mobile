class ParentalControlModel{
  int id;
  String name;
  ParentalControlModel({required this.name,required this.id});

  factory ParentalControlModel.fromJson(Map<String,dynamic> json){
    return ParentalControlModel(name: json["name"], id: json["id"]);
  }
}