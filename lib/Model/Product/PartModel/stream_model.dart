class Streaming {
  Streaming({
    required this.href,
    required this.title,
  });
  late final String href;
  late final String title;

  Streaming.fromJson(Map<String, dynamic> json){
    href = json["href"];
    title = json["title"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['href'] = href;
    _data['title'] = title;
    return _data;
  }
}