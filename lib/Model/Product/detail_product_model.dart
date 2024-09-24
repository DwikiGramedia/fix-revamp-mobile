import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/author_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/borrow_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/rating_model.dart';

class DetailProductModel {
  //bool isFeatured;
  List<String>? extraItems;
  int? parentalControlId;
  //int printedCurrencyCode;
  int? pageCount;
  int? itemStatus;
  int? brandId;
  String? thumbImageNormal;
  //int meta;
  //int revisionNumber;
  String? fileSize;
  String? imageNormal;
  int? id;
  String? editionCode;
  String? description;
  //bool isWebreader;
  //bool isInternalContent;
  //int readingDirection;
  int? itemDistributionCountryGroupId;
  DateTime? releaseSchedule;
  String? gtin13;
  //int subsWeight;
  //bool isActive;
  //BrandModel brand;
  int? itemTypeId;
  String? gtin8;
  int? contentType;
  //bool isLastest;
  String? slug;
  String? imageHighres;
  //int sortPriority;
  String? name;
  DateTime? created;
  DateTime? releaseDate;
  //bool isExtra;
  //ParentalControlModel parentalControl;
  List<String>? previews;

  DetailProductModel(
      {this.id,
      this.name,
      this.pageCount,
      this.previews,
      this.description,
      this.fileSize,
      this.editionCode,
      // this.isActive,
      //  this.brand,
      this.brandId,
      this.contentType,
      this.created,
      this.extraItems,
      this.gtin8,
      this.gtin13,
      this.imageHighres,
      this.imageNormal,
      // this.isExtra,
      // this.isFeatured,
      // this.isInternalContent,
      // this.isLastest,
      // this.isWebreader,
      this.itemDistributionCountryGroupId,
      this.itemStatus,
      this.itemTypeId,
      // this.meta,
      // this.parentalControl,
      this.parentalControlId,
      //  this.printedCurrencyCode,
      // this.readingDirection,
      this.releaseDate,
      this.releaseSchedule,
      // this.revisionNumber,
      this.slug,
      // this.sortPriority,
      // this.subsWeight,
      this.thumbImageNormal});

  factory DetailProductModel.fromJson(Map<String, dynamic> json) {
    return DetailProductModel(
      id: getJsonValueAsInt(json, 'id'),
      name: getJsonValueAsString(json, 'name'),
      pageCount: getJsonValueAsInt(json, 'page_count'),
      previews: getJsonValueAsStringList(json, 'previews'),
      description: getJsonValueAsString(json, 'description'),
      fileSize: getJsonValueAsString(json, 'file_size'),
      editionCode: getJsonValueAsString(json, 'edition_code'),
      //isActive: json["is_active"],
      // brand: BrandModel.fromJson(json["brand"]),
      brandId: getJsonValueAsInt(json, 'brand_id'),
      contentType: getJsonValueAsInt(json, 'content_type'),
      created: getJsonValueAsDateTime(json, 'created'),
      extraItems: <String>[],
      gtin8: getJsonValueAsString(json, 'gtin8'),
      gtin13: getJsonValueAsString(json, 'gtin13'),
      imageHighres: getJsonValueAsString(json, 'image_highres'),
      imageNormal: getJsonValueAsString(json, 'image_normal'),
      //isExtra: json["is_extra"],
      //isFeatured: json["is_featured"],
      // isInternalContent: json["is_internal_content"],
      // isLastest: json["is_lastest"],
      // isWebreader: json["is_web_reader"],
      itemDistributionCountryGroupId:
          getJsonValueAsInt(json, 'item_distribution_country_group_id'),
      itemStatus: getJsonValueAsInt(json, 'item_status'),
      itemTypeId: getJsonValueAsInt(json, 'item_type_id'),
      //meta: json["meta"] ?? 0,
      //parentalControl:ParentalControlModel.fromJson(json["parental_control"]),
      parentalControlId: getJsonValueAsInt(json, 'parental_control_id'),
      // printedCurrencyCode: json["printed_currency_code"] ?? 0,
      //readingDirection: json["reading_direction"],
      releaseDate: getJsonValueAsDateTime(json, 'release_date'),
      releaseSchedule: getJsonValueAsDateTime(json, 'release_schedule'),
      //revisionNumber: json["revision_number"],
      slug: getJsonValueAsString(json, 'slug'),
      //sortPriority: json["sort_priority"],
      //subsWeight: json["subs_weight"],
      thumbImageNormal: getJsonValueAsString(json, 'thumb_image_normal'),
    );
  }
}

class ItemInfoModel {
  List<AuthorModel>? authors;
  BorrowItemModel? borrowItem;
  ItemInfoDetail? brand;
  ItemInfoDetail? catalog;
  List<ItemInfoDetail>? categories;
  ItemInfoPreview? categoriesIcon;
  String? categoriesOfItem;
  int? countUserId;
  ItemInfoPreview? coverImage;
  int? currentlyAvailable;
  String? description;
  ItemInfoDetail? details;
  String? editionCode;
  String? fileSize;
  ItemInfoPreview? highResImage;
  String? href;
  int? id;
  bool? isOwnedByOrganization;
  String? contentType;
  String? itemType;
  String? maxBorrowTime;
  String? newSubtitle;
  String? newTitle;
  dynamic nextAvailable;
  int? organizationId;
  int? pageCount;
  List<ItemInfoPreview>? preview;
  RatingModel? rating;
  bool? reviewStatus;
  String? subtitle;
  String? title;
  int? totalInCollection;
  int? userId;
  ItemInfoPreview? vendor;
  bool? watchList;
  ItemInfoModel(
      {this.authors,
      this.borrowItem,
      this.brand,
      this.catalog,
      this.categories,
      this.categoriesIcon,
      this.categoriesOfItem,
      this.countUserId,
      this.coverImage,
      this.currentlyAvailable,
      this.description,
      this.details,
      this.editionCode,
      this.fileSize,
      this.highResImage,
      this.href,
      this.id,
      this.isOwnedByOrganization,
      this.itemType,
      this.maxBorrowTime,
      this.newSubtitle,
      this.newTitle,
      this.nextAvailable,
      this.organizationId,
      this.pageCount,
      this.preview,
      this.rating,
      this.reviewStatus,
      this.subtitle,
      this.title,
      this.totalInCollection,
      this.userId,
      this.vendor,
      this.watchList,
      this.contentType});

  factory ItemInfoModel.fromJson(json) {
    return ItemInfoModel(
        authors: getJsonListValue(json, 'authors')
            .map<AuthorModel>((dynamic value) => AuthorModel.fromJson(value))
            .toList(),
        borrowItem: BorrowItemModel.fromJson(
          getJsonValueAsJson(json, 'borrow_item'),
        ),
        brand: ItemInfoDetail.fromJson(
          getJsonValueAsJson(json, 'brand'),
        ),
        catalog: ItemInfoDetail.fromJson(
          getJsonValueAsJson(json, 'catalog'),
        ),
        categories: getJsonListValue(json, 'categories')
            .map<ItemInfoDetail>(
                (dynamic value) => ItemInfoDetail.fromJson(value))
            .toList(),
        categoriesIcon: ItemInfoPreview.fromJson(
          getJsonValueAsJson(json, 'categories_icon'),
        ),
        categoriesOfItem: getJsonValueAsString(json, "categories_of_item"),
        countUserId: getJsonValueAsInt(json, "count_user_id"),
        coverImage: ItemInfoPreview.fromJson(
          getJsonValueAsJson(json, 'cover_image'),
        ),
        currentlyAvailable: getJsonValueAsInt(json, "currently_available"),
        description: getJsonValueAsString(json, "description"),
        details: ItemInfoDetail.fromJson(
          getJsonValueAsJson(json, 'details'),
        ),
        editionCode: getJsonValueAsString(json, "edition_code"),
        fileSize: getJsonValueAsString(json, "file_size"),
        highResImage: ItemInfoPreview.fromJson(
          getJsonValueAsJson(json, 'high_res_image'),
        ),
        href: getJsonValueAsString(json, "href"),
        id: getJsonValueAsInt(json, "id"),
        isOwnedByOrganization:
            getJsonValueAsBool(json, "is_owned_by_organization"),
        itemType: getJsonValueAsString(json, "item_type"),
        maxBorrowTime: getJsonValueAsString(json, "max_borrow_time"),
        newSubtitle: getJsonValueAsString(json, "new_subtitle"),
        newTitle: getJsonValueAsString(json, "new_title"),
        nextAvailable: getJsonValue(json, "next_available"),
        organizationId: getJsonValueAsInt(json, "organization_id"),
        pageCount: getJsonValueAsInt(json, "page_count"),
        preview: getJsonListValue(json, 'previews')
            .map<ItemInfoPreview>(
                (dynamic value) => ItemInfoPreview.fromJson(value))
            .toList(),
        rating: RatingModel.fromJson(
          getJsonValueAsJson(json, 'rating'),
        ),
        reviewStatus: getJsonValueAsBool(json, "review_status"),
        subtitle: getJsonValueAsString(json, "subtitle"),
        title: getJsonValueAsString(json, "title"),
        totalInCollection: getJsonValueAsInt(json, "total_in_collection"),
        userId: getJsonValueAsInt(json, "user_id"),
        vendor: ItemInfoPreview.fromJson(getJsonValueAsJson(json, 'vendor')),
        watchList: getJsonValueAsBool(json, "watch_list"),
        contentType: getJsonValueAsString(json, "content_type"));
  }
}

class ItemInfoPreview {
  String? href;
  String? title;
  ItemInfoPreview({
    this.href,
    this.title,
  });

  factory ItemInfoPreview.fromJson(Map<String, dynamic> json) {
    return ItemInfoPreview(
      href: getJsonValueAsString(json, 'href'),
      title: getJsonValueAsString(json, 'title'),
    );
  }

  Map<String, dynamic> toJson() {
    return {"href": href, "title": title};
  }
}

class ItemInfoDetail {
  String? contentType;
  String? href;
  int? id;
  String? title;
  ItemInfoDetail({
    this.contentType,
    this.href,
    this.id,
    this.title,
  });

  factory ItemInfoDetail.fromJson(Map<String, dynamic> json) {
    return ItemInfoDetail(
      contentType: getJsonValueAsString(json, 'content_type'),
      href: getJsonValueAsString(json, 'href'),
      id: getJsonValueAsInt(json, 'id'),
      title: getJsonValueAsString(json, 'title'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'href': href, 'title': title};
  }
}
