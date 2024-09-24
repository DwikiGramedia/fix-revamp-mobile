import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/details_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';

import 'PartModel/vendor_model.dart';

class BorrowedBookModel {
  int id;
  String title;
  String urlDownload;
  CoverImage coverImage;
  Details details;
  Vendor vendor;
  String fileType;
  BorrowedBookItemModel bookItem;
  String href;
  ItemInfoPreview catalogItem;
  ItemInfoPreview download;
  String expires;

  BorrowedBookModel({
    required this.title,
    required this.id,
    required this.urlDownload,
    required this.coverImage,
    required this.details,
    required this.vendor,
    required this.fileType,
    required this.bookItem,
    required this.href,
    required this.catalogItem,
    required this.download,
    required this.expires,
  });

  factory BorrowedBookModel.fromJson(Map<String, dynamic> json) {
    return BorrowedBookModel(
      title: getJsonValueAsString(json, "title"),
      id: getJsonValueAsInt(json, "id"),
      urlDownload: json["download"]["href"],
      coverImage: CoverImage.fromJson(getJsonValueAsJson(json, 'cover_image')),
      details: Details.fromJson(getJsonValueAsJson(json, 'details')),
      vendor: Vendor.fromJson(getJsonValueAsJson(json, 'vendor')),
      fileType: getJsonValueAsString(json, "file_type"),
      bookItem: BorrowedBookItemModel.fromJson(
        getJsonValueAsJson(json, 'catalog_item'),
      ),
      href: getJsonValueAsString(json, "href"),
      catalogItem: ItemInfoPreview.fromJson(
        getJsonValueAsJson(json, 'catalog_item'),
      ),
      download: ItemInfoPreview.fromJson(
        getJsonValueAsJson(json, 'download'),
      ),
      expires: getJsonValueAsString(json, "expires"),
    );
  }
}

class BorrowedBookItemModel {
  String title;
  String href;

  BorrowedBookItemModel({
    required this.title,
    required this.href,
  });

  factory BorrowedBookItemModel.fromJson(Map<String, dynamic> json) {
    return BorrowedBookItemModel(
      title: getJsonValueAsString(json, "title"),
      href: getJsonValueAsString(json, "href"),
    );
  }
}
