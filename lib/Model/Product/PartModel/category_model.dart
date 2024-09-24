class CategoryModel {
  String? href;
  String? title;
  int? id;
  CategoryModel({required this.href, required this.title, required this.id});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    href = json["href"];
    title = json["title"];
    id = json["id"];
  }
  Map<String,dynamic> toJson(){
    return {
      'href':href,
      'title':title,
      'id':id
    };
  }
}
