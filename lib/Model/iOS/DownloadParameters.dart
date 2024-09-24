class DownloadParameters {
  int id;
  String token;
  String editionCode;
  int brandId;
  String fileType;
  String item_type;
  String key;
  String email;
  int userId;
  String watermark;
  String company;
  int clientId;
  int borrowedId;
  int catalogId;
  int organizationId;
  String expires;

  DownloadParameters({
    required this.id,
    required this.token,
    required this.brandId,
    required this.editionCode,
    required this.fileType,
    required this.key,
    required this.email,
    required this.userId,
    required this.watermark,
    required this.company,
    required this.clientId,
    required this.catalogId,
    required this.borrowedId,
    required this.organizationId,
    required this.item_type,
    this.expires = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": id,
      "token": token,
      "editionCode": editionCode,
      "brandId": brandId,
      "fileType": fileType,
      "key": key,
      "email": email,
      "user_id": userId,
      "watermark": watermark,
      "company": company,
      "clientId": clientId,
      "catalogId": catalogId,
      "borrowedId": borrowedId,
      "organizationId": organizationId,
      "item_type":item_type,
      "expires": expires,
    };
  }
}
