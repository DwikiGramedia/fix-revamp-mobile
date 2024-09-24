class HighResImageModel{
  String href;
  String title;
  HighResImageModel({required this.title,required this.href});

  Map<String,dynamic> toJson(){
    return {
      "href":href,
      "title":title
    };
  }
}