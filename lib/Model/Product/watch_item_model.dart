import 'package:revamp_eperpus_mobile/model/Product/PartModel/borrow_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/catalog_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/details_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/vendor_model.dart';

class WatchItemModel {
  BorrowItemModel borrowedItemModel;
  Catalog catalog;
  CoverImage coverImage;
  int currentlyAvailable;
  String? delete;
  Details details;
  //String? endDate;
  String? href;
  int id;
  String? maxBorrowTime;
  String? title;
  Vendor vendor;

  WatchItemModel(
      {required this.details,
      required this.coverImage,
      required this.catalog,
      required this.borrowedItemModel,
      required this.href,
      required this.id,
      required this.title,
      required this.delete,
      required this.currentlyAvailable,
      // required this.endDate,
      required this.maxBorrowTime,
      required this.vendor});

  factory WatchItemModel.fromJson(Map<String, dynamic> json) {
    return WatchItemModel(
        details: Details.fromJson(json["details"]),
        coverImage: CoverImage.fromJson(json["cover_image"]),
        catalog: Catalog.fromJson(json["catalog"]),
        borrowedItemModel: BorrowItemModel.fromJson(json["borrow_item"]),
        href: json["href"] ?? "",
        id: json["id"] ?? 0,
        title: json["title"],
        delete: json["delete"],
        currentlyAvailable: json["currently_available"],
        //endDate: json["end_date"] ?? "",
        maxBorrowTime: json["max_borrow_time"] ?? "",
        vendor: Vendor.fromJson(json["vendor"]));
  }
}
