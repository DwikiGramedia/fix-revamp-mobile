class PreviewsModel {
  String? href;
  String? title;
  PreviewsModel({required this.title, required this.href});

  PreviewsModel.fromJson(Map<String, dynamic> json) {
    href = json['href'] == null ? "" : json['href']as String;
    title = json['title'] == null ? "" : json['title'] as String;
  }

  Map<String,dynamic> toJson(){
    return {
      'href':href,
      'title':title
    };
  }
}