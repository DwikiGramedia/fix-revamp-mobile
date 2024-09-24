import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/borrow_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/rating_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/vendor_model.dart';

import 'PartModel/details_model.dart';

class LibraryProductModel {
  BorrowItemModel? borrowItem;
  String? categoriesOfItem;
  int? countUserId;
  CoverImage? coverImage;
  int? currentlyAvailable;
  String? description;
  Details? details;
  String? fileSize;
  String? href;
  int? pageCount;
  int? id;
  bool? isOwnedByOrganization;
  String? itemType;
  String? maxBorrowTime;
  String? newSubtitle;
  String? newTitle;
  RatingModel? rating;
  String? title;
  String? subtitle;
  int? totalInCollection;
  List<int>? userId;
  Vendor? vendor;
  //List<String>? previews;
  LibraryProductModel({
    this.borrowItem,
    this.categoriesOfItem,
    this.countUserId,
    this.coverImage,
    this.currentlyAvailable,
    this.description,
    this.details,
    this.href,
    this.fileSize,
    this.id,
    this.isOwnedByOrganization,
    this.itemType,
    this.maxBorrowTime,
    this.newSubtitle,
    this.newTitle,
    this.title,
    this.subtitle,
    this.rating,
    this.totalInCollection,
    this.userId,
    this.vendor,
    /* required this.previews*/ this.pageCount,
  });

  factory LibraryProductModel.fromJson(Map<String, dynamic> json) {
    return LibraryProductModel(
      borrowItem:
          BorrowItemModel.fromJson(getJsonValueAsJson(json, 'borrow_item')),
      categoriesOfItem: getJsonValueAsString(json, 'categories_of_item'),
      countUserId: getJsonValueAsInt(json, 'count_user_id'),
      coverImage: CoverImage.fromJson(getJsonValueAsJson(json, 'cover_image')),
      currentlyAvailable: getJsonValueAsInt(json, 'currently_available'),
      description: getJsonValueAsString(json, 'description'),
      details: Details.fromJson(getJsonValueAsJson(json, 'details')),
      href: getJsonValueAsString(json, 'href'),
      fileSize: getJsonValueAsString(json, 'file_size'),
      id: getJsonValueAsInt(json, 'id'),
      isOwnedByOrganization:
          getJsonValueAsBool(json, 'is_owned_by_organization'),
      itemType: getJsonValueAsString(json, 'item_type'),
      maxBorrowTime: getJsonValueAsString(json, 'max_borrow_time'),
      newSubtitle: getJsonValueAsString(json, 'new_subtitle'),
      newTitle: getJsonValueAsString(json, 'new_title'),
      title: getJsonValueAsString(json, 'title'),
      subtitle: getJsonValueAsString(json, 'subtitle'),
      rating: RatingModel.fromJson(getJsonValueAsJson(json, 'rating')),
      totalInCollection: getJsonValueAsInt(json, 'total_in_collection'),
      userId: getJsonValueAsIntList(json, 'user_id'),
      vendor: Vendor.fromJson(getJsonValueAsJson(json, 'vendor')),
      /*previews: json['previews'] == null
            ? [CoverImage.fromJson(json['cover_image']).href!]
            : previewJsonArray(json['previews']),*/
      pageCount: getJsonValueAsInt(json, 'page_count'),
    );
  }

  // List<LibraryProductModel> fromJsonArray(List<dynamic> data) {
  //   return data.map((datum) => ProductData.fromJson(datum)).toList();
  // }

  static List<String> previewJsonArray(List<dynamic> data) {
    return data.map((datum) => datum['href'].toString()).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating?.toJson(),
      'vendor': vendor?.toJson(),
      'user_id': userId,
      'total_in_collection': totalInCollection,
      'subtitle': subtitle,
      'title': title,
      'new_title': newTitle,
      'new_subtitle': newSubtitle,
      'max_borrow_time': maxBorrowTime,
      'item_type': itemType,
      'is_owned_by_organization': isOwnedByOrganization,
      'file_size': fileSize,
      'href': href,
      'details': details?.toJson(),
      'description': description,
      'currently_available': currentlyAvailable,
      'cover_image': coverImage?.toJson(),
      'count_user_id': countUserId,
      'borrow_item': borrowItem?.toJson(),
      //'previews':previews,
      'page_count': pageCount,
      'categories_of_item': categoriesOfItem
    };
  }
}
