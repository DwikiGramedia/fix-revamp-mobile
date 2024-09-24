class Download {
  String? href;
  String? title;
  Download({required this.title, required this.href});

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(title: json["title"], href: json["href"]);
  }
  Map<String,dynamic> toJson(){
    return {
      'href':href,
      'title':title
    };
  }
}
