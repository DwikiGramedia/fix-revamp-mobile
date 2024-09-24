import 'package:revamp_eperpus_mobile/model/Product/PartModel/author_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/borrow_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/brand_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/catalog_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/categories_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/high_res_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/rating_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/vendor_model.dart';

class BorrowProductBodyModel {
  List<AuthorModel> authorsModel;
  BrandModel brandModel;
  Catalog catalog;
  Categories categories;
  String description;
  String editionCode;
  String fileSize;
  HighResImageModel highResImageModel;
  int organizationId;
  bool isOwnedByOrganization;
  int pageCount;
  List<String> previews;
  bool reviewStatus;
  Vendor vendor;
  BorrowItemModel borrowItemModel;
  CoverImage coverImage;
  int currentlyAvailable;
  int id;
  bool isUserItem;
  String itemType;
  DateTime maxBorrowTime;
  String newSubtitle;
  String newTitle;
  RatingModel ratingModel;
  String subtitle;
  int totalInCollection;
  String href;
  String title;

  BorrowProductBodyModel(
      {required this.ratingModel,
      required this.coverImage,
      required this.borrowItemModel,
      required this.vendor,
      required this.highResImageModel,
      required this.title,
      required this.href,
      required this.categories,
      required this.catalog,
      required this.brandModel,
      required this.authorsModel,
      required this.id,
      required this.currentlyAvailable,
      required this.fileSize,
      required this.previews,
      required this.editionCode,
      required this.description,
      required this.pageCount,
      required this.isOwnedByOrganization,
      required this.itemType,
      required this.maxBorrowTime,
      required this.newSubtitle,
      required this.newTitle,
      required this.subtitle,
      required this.totalInCollection,
      required this.organizationId,
      required this.reviewStatus,
      required this.isUserItem});

  Map<String,dynamic> toJson(){
    return {
      "authors":authorsModel,
      "brand":brandModel.toJson(),
      "catalog":catalog.toJson(),
      "categories":categories.toJson(),
      "description":description,
      "edition_code":editionCode,
      "file_size":fileSize,
      "high_res_image":highResImageModel.toJson(),
      "organization_id":organizationId,
      "is_owned_by_organization":isOwnedByOrganization,
      "page_count":pageCount,
      "previews":previews,
      "review_status":reviewStatus,
      "vendor":vendor.toJson(),
      "borrow_item":borrowItemModel.toJson(),
      "cover_image":coverImage.toJson(),
      "currently_available":currentlyAvailable,
      "id":id,
      "isUserItem":isUserItem,
      "item_type":itemType,
      "max_borrow_item":maxBorrowTime.toString(),
      "new_subtitle":newSubtitle,
      "new_title":newTitle,
      "rating":ratingModel.toJson(),
      "subtitle":subtitle,
      "total_in_collection":totalInCollection,
      "href":href,
      "title":title
    };
  }
}
