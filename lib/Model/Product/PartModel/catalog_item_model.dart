class CatalogItem {
  String? href;
  String? title;
  CatalogItem({required this.title, required this.href});

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    return CatalogItem(title: json["title"], href: json["href"]);
  }
  Map<String,dynamic> toJson(){
    return {
      'href':href,
      'title':title
    };
  }
}