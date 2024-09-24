class ProductKey {
  String key;
  String fileExtension;
  ProductKey({required this.key,required this.fileExtension});

   factory ProductKey.fromJson(Map<String,dynamic> json){
    return ProductKey(key: json["key"], fileExtension: json["file_type"]);
  }
}