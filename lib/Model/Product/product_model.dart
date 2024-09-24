import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

import 'PartModel/catalog_item_model.dart';
import 'PartModel/catalog_model.dart';
import 'PartModel/category_model.dart';
import 'PartModel/cover_image_model.dart';

import 'PartModel/details_model.dart';
import 'PartModel/vendor_model.dart';

class ListProductModel {
  List<HistoryBorrowProductModel>? items;
  ListProductModel({this.items});
  @override
  // TODO: implement props

  factory ListProductModel.fromJson(Map<String, dynamic> json) {
    return ListProductModel(
        items: getJsonListValue(json, 'items')
            .map<HistoryBorrowProductModel>(
                (dynamic value) => HistoryBorrowProductModel.fromJson(value))
            .toList());
  }
}

class HistoryBorrowProductModel {
  DateTime? borrowingStartTIME;
  Catalog? catalog;
  CatalogItem? catalogItem;
  List<CategoryModel>? categories;
  CoverImage? coverImage;
  int? currentlyAvailable;
  Details? details;
  String? expires;
  String? new_title;
  String? new_subtitle;
  String? fileSize;
  int? id;
  bool? isWebReader;
  bool? reviewStatus;
  DateTime? returned_time;
  int? pageCount;
  String? title;
  Vendor? vendor;

  HistoryBorrowProductModel({
    this.categories,
    this.details,
    this.coverImage,
    this.catalogItem,
    this.catalog,
    this.expires,
    this.currentlyAvailable,
    this.borrowingStartTIME,
    this.new_subtitle,
    this.new_title,
    this.id,
    this.fileSize,
    this.title,
    this.isWebReader,
    this.pageCount,
    this.returned_time,
    this.reviewStatus,
    this.vendor,
  });
  factory HistoryBorrowProductModel.fromJson(Map<String, dynamic> json) {
    return HistoryBorrowProductModel(
      categories: getJsonListValue(json, 'categories')
          .map<CategoryModel>((dynamic value) => CategoryModel.fromJson(value))
          .toList(),
      details: Details.fromJson(getJsonValueAsJson(json, 'details')),
      coverImage: CoverImage.fromJson(getJsonValueAsJson(json, 'cover_image')),
      catalogItem:
          CatalogItem.fromJson(getJsonValueAsJson(json, 'catalog_item')),
      catalog: Catalog.fromJson(getJsonValueAsJson(json, 'catalog')),
      expires: getJsonValueAsString(json, 'expires'),
      currentlyAvailable: json['currently_available'],
      borrowingStartTIME: getJsonValueAsDateTime(json, 'borrowing_start_time'),
      new_subtitle: getJsonValueAsString(json, 'new_subtitle'),
      new_title: getJsonValueAsString(json, 'new_title'),
      isWebReader: getJsonValueAsBool(json, 'is_webreader'),
      title: getJsonValueAsString(json, 'title'),
      fileSize: getJsonValueAsString(json, 'file_size'),
      reviewStatus: getJsonValueAsBool(json, 'review_status'),
      returned_time: getJsonValueAsDateTime(json, 'returned_time'),
      id: getJsonValueAsInt(json, 'id'),
      pageCount: getJsonValueAsInt(json, 'page_count'),
      vendor: Vendor.fromJson(getJsonValueAsJson(json, 'vendor')),
    );
  }
}
