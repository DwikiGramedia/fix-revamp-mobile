class FileProduct{
  String url;
  String fileType;
  int? borrowedId;
  int? id;
  String? expires;
  FileProduct({required this.fileType,required this.url, this.borrowedId,this.id, this.expires});
}