class Owner {
  Owner({
    required this.href,
    required this.rel,
    required this.title,
  });
  late final String href;
  late final String rel;
  late final String title;

  Owner.fromJson(Map<String, dynamic> json){
    href = json['href'];
    rel = json['rel'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['href'] = href;
    _data['rel'] = rel;
    _data['title'] = title;
    return _data;
  }
}
