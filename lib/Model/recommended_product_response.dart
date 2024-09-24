

class GetRecommendationBooks {
  final List<RecomendationItem>? items;
  final Metadata? metadata;

  GetRecommendationBooks({
    this.items,
    this.metadata,
  });

  GetRecommendationBooks.fromJson(Map<String, dynamic> json)
      : items = (json['items'] as List?)?.map((dynamic e) => RecomendationItem.fromJson(e as Map<String,dynamic>)).toList(),
        metadata = (json['metadata'] as Map<String,dynamic>?) != null ? Metadata.fromJson(json['metadata'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'items' : items?.map((e) => e.toJson()).toList(),
    'metadata' : metadata?.toJson()
  };
}

class RecomendationItem {
  //final List<dynamic>? allowedCountries;
  //final List<Author>? authors;
  final Brand? brand;
  final int? brandId;
  final int? contentType;
  //final List<DisplayOffers>? displayOffers;
  //final DisplayPrice? displayPrice;
  final String? editionCode;
  final dynamic filenames;
  final int? id;
  //final dynamic imageHighres;
  final bool? isActive;
  final bool? isExtra;
  final bool? isFeatured;
  final bool? isLatest;
  final String? issueNumber;
  final int? itemStatus;
  final ItemType? itemType;
  final int? itemTypeId;
  final List<Languages>? languages;
  final String? mediaBaseUrl;
  final String? name;
  //final dynamic pageCount;
  final int? parentalControlId;
  final String? printedCurrencyCode;
  final String? printedPrice;
  final int? readingDirection;
  final String? releaseDate;
  final String? releaseSchedule;
  //final List<dynamic>? restrictedCountries;
  final String? slug;
  final String? thumbImageHighres;
  final String? thumbImageNormal;
  final Vendor? vendor;
  final bool? webReaderFilesReady;

  RecomendationItem({
    //this.allowedCountries,
    //this.authors,
    this.brand,
    this.brandId,
    this.contentType,
    //this.displayOffers,
    //this.displayPrice,
    this.editionCode,
    this.filenames,
    this.id,
    //this.imageHighres,
    this.isActive,
    this.isExtra,
    this.isFeatured,
    this.isLatest,
    this.issueNumber,
    this.itemStatus,
    this.itemType,
    this.itemTypeId,
    this.languages,
    this.mediaBaseUrl,
    this.name,
    //this.pageCount,
    this.parentalControlId,
    this.printedCurrencyCode,
    this.printedPrice,
    this.readingDirection,
    this.releaseDate,
    this.releaseSchedule,
    //this.restrictedCountries,
    this.slug,
    this.thumbImageHighres,
    this.thumbImageNormal,
    this.vendor,
    this.webReaderFilesReady,
  });

  RecomendationItem.fromJson(Map<String, dynamic> json)
      : //allowedCountries = json['allowed_countries'] as List?,
        //authors = (json['authors'] as List?)?.map((dynamic e) => AuthorModel.fromJson(e as Map<String,dynamic>)).toList(),
        brand = (json['brand'] as Map<String,dynamic>?) != null ? Brand.fromJson(json['brand'] as Map<String,dynamic>) : null,
        brandId = json['brand_id'] as int?,
        contentType = json['content_type'] as int?,
        //displayOffers = (json['display_offers'] as List?)?.map((dynamic e) => DisplayOffers.fromJson(e as Map<String,dynamic>)).toList(),
        //displayPrice = (json['display_price'] as Map<String,dynamic>?) != null ? DisplayPrice.fromJson(json['display_price'] as Map<String,dynamic>) : null,
        editionCode = json['edition_code'] as String?,
        filenames = json['filenames'],
        id = json['id'] as int?,
        //imageHighres = json['image_highres'],
        isActive = json['is_active'] as bool?,
        isExtra = json['is_extra'] as bool?,
        isFeatured = json['is_featured'] as bool?,
        isLatest = json['is_latest'] as bool?,
        issueNumber = json['issue_number'] as String?,
        itemStatus = json['item_status'] as int?,
        itemType = (json['item_type'] as Map<String,dynamic>?) != null ? ItemType.fromJson(json['item_type'] as Map<String,dynamic>) : null,
        itemTypeId = json['item_type_id'] as int?,
        languages = (json['languages'] as List?)?.map((dynamic e) => Languages.fromJson(e as Map<String,dynamic>)).toList(),
        mediaBaseUrl = json['media_base_url'] as String?,
        name = json['name'] as String?,
        //pageCount = json['page_count'],
        parentalControlId = json['parental_control_id'] as int?,
        printedCurrencyCode = json['printed_currency_code'] as String?,
        printedPrice = json['printed_price'] as String?,
        readingDirection = json['reading_direction'] as int?,
        releaseDate = json['release_date'] as String?,
        releaseSchedule = json['release_schedule'] as String?,
        //restrictedCountries = json['restricted_countries'] as List?,
        slug = json['slug'] as String?,
        thumbImageHighres = json['thumb_image_highres'] as String?,
        thumbImageNormal = json['thumb_image_normal'] as String?,
        vendor = (json['vendor'] as Map<String,dynamic>?) != null ? Vendor.fromJson(json['vendor'] as Map<String,dynamic>) : null,
        webReaderFilesReady = json['web_reader_files_ready'] as bool?;

  Map<String, dynamic> toJson() => {
    //'allowed_countries' : allowedCountries,
    //'authors' : authors?.map((e) => e.toJson()).toList(),
    'brand' : brand?.toJson(),
    'brand_id' : brandId,
    'content_type' : contentType,
    //'display_offers' : displayOffers?.map((e) => e.toJson()).toList(),
    //'display_price' : displayPrice?.toJson(),
    'edition_code' : editionCode,
    'filenames' : filenames,
    'id' : id,
    //'image_highres' : imageHighres,
    'is_active' : isActive,
    'is_extra' : isExtra,
    'is_featured' : isFeatured,
    'is_latest' : isLatest,
    'issue_number' : issueNumber,
    'item_status' : itemStatus,
    'item_type' : itemType?.toJson(),
    'item_type_id' : itemTypeId,
    'languages' : languages?.map((e) => e.toJson()).toList(),
    'media_base_url' : mediaBaseUrl,
    'name' : name,
    //'page_count' : pageCount,
    'parental_control_id' : parentalControlId,
    'printed_currency_code' : printedCurrencyCode,
    'printed_price' : printedPrice,
    'reading_direction' : readingDirection,
    'release_date' : releaseDate,
    'release_schedule' : releaseSchedule,
    //'restricted_countries' : restrictedCountries,
    'slug' : slug,
    'thumb_image_highres' : thumbImageHighres,
    'thumb_image_normal' : thumbImageNormal,
    'vendor' : vendor?.toJson(),
    'web_reader_files_ready' : webReaderFilesReady
  };
}



class Brand {
  final int? id;
  final String? name;
  final String? slug;

  Brand({
    this.id,
    this.name,
    this.slug,
  });

  Brand.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        slug = json['slug'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'slug' : slug
  };
}

class DisplayOffers {
  final dynamic colors;
  final List<int>? discountId;
  final String? discountName;
  final List<int>? discountPaymentgatewayId;
  final String? discountPriceIdr;
  final int? discountPricePoint;
  final String? discountPriceUsd;
  final String? discountTag;
  final String? imageHighres;
  final String? imageNormal;
  final bool? isDiscount;
  final bool? isFree;
  final String? mediaBaseUrl;
  final int? offerId;
  final String? offerName;
  final int? offerTypeId;
  final List<int>? platformId;
  final String? priceIdr;
  final int? pricePoint;
  final String? priceUsd;

  DisplayOffers({
    this.colors,
    this.discountId,
    this.discountName,
    this.discountPaymentgatewayId,
    this.discountPriceIdr,
    this.discountPricePoint,
    this.discountPriceUsd,
    this.discountTag,
    this.imageHighres,
    this.imageNormal,
    this.isDiscount,
    this.isFree,
    this.mediaBaseUrl,
    this.offerId,
    this.offerName,
    this.offerTypeId,
    this.platformId,
    this.priceIdr,
    this.pricePoint,
    this.priceUsd,
  });

  DisplayOffers.fromJson(Map<String, dynamic> json)
      : colors = json['colors'],
        discountId = (json['discount_id'] as List?)?.map((dynamic e) => e as int).toList(),
        discountName = json['discount_name'] as String?,
        discountPaymentgatewayId = (json['discount_paymentgateway_id'] as List?)?.map((dynamic e) => e as int).toList(),
        discountPriceIdr = json['discount_price_idr'] as String?,
        discountPricePoint = json['discount_price_point'] as int?,
        discountPriceUsd = json['discount_price_usd'] as String?,
        discountTag = json['discount_tag'] as String?,
        imageHighres = json['image_highres'] as String?,
        imageNormal = json['image_normal'] as String?,
        isDiscount = json['is_discount'] as bool?,
        isFree = json['is_free'] as bool?,
        mediaBaseUrl = json['media_base_url'] as String?,
        offerId = json['offer_id'] as int?,
        offerName = json['offer_name'] as String?,
        offerTypeId = json['offer_type_id'] as int?,
        platformId = (json['platform_id'] as List?)?.map((dynamic e) => e as int).toList(),
        priceIdr = json['price_idr'] as String?,
        pricePoint = json['price_point'] as int?,
        priceUsd = json['price_usd'] as String?;

  Map<String, dynamic> toJson() => {
    'colors' : colors,
    'discount_id' : discountId,
    'discount_name' : discountName,
    'discount_paymentgateway_id' : discountPaymentgatewayId,
    'discount_price_idr' : discountPriceIdr,
    'discount_price_point' : discountPricePoint,
    'discount_price_usd' : discountPriceUsd,
    'discount_tag' : discountTag,
    'image_highres' : imageHighres,
    'image_normal' : imageNormal,
    'is_discount' : isDiscount,
    'is_free' : isFree,
    'media_base_url' : mediaBaseUrl,
    'offer_id' : offerId,
    'offer_name' : offerName,
    'offer_type_id' : offerTypeId,
    'platform_id' : platformId,
    'price_idr' : priceIdr,
    'price_point' : pricePoint,
    'price_usd' : priceUsd
  };
}

class DisplayPrice {
  final dynamic colors;
  final List<int>? discountId;
  final String? discountName;
  final List<int>? discountPaymentgatewayId;
  final String? discountPriceIdr;
  final int? discountPricePoint;
  final String? discountPriceUsd;
  final String? discountTag;
  final String? imageHighres;
  final String? imageNormal;
  final bool? isDiscount;
  final bool? isFree;
  final String? mediaBaseUrl;
  final int? offerId;
  final String? offerName;
  final int? offerTypeId;
  final List<int>? platformId;
  final String? priceIdr;
  final int? pricePoint;
  final String? priceUsd;

  DisplayPrice({
    this.colors,
    this.discountId,
    this.discountName,
    this.discountPaymentgatewayId,
    this.discountPriceIdr,
    this.discountPricePoint,
    this.discountPriceUsd,
    this.discountTag,
    this.imageHighres,
    this.imageNormal,
    this.isDiscount,
    this.isFree,
    this.mediaBaseUrl,
    this.offerId,
    this.offerName,
    this.offerTypeId,
    this.platformId,
    this.priceIdr,
    this.pricePoint,
    this.priceUsd,
  });

  DisplayPrice.fromJson(Map<String, dynamic> json)
      : colors = json['colors'],
        discountId = (json['discount_id'] as List?)?.map((dynamic e) => e as int).toList(),
        discountName = json['discount_name'] as String?,
        discountPaymentgatewayId = (json['discount_paymentgateway_id'] as List?)?.map((dynamic e) => e as int).toList(),
        discountPriceIdr = json['discount_price_idr'] as String?,
        discountPricePoint = json['discount_price_point'] as int?,
        discountPriceUsd = json['discount_price_usd'] as String?,
        discountTag = json['discount_tag'] as String?,
        imageHighres = json['image_highres'] as String?,
        imageNormal = json['image_normal'] as String?,
        isDiscount = json['is_discount'] as bool?,
        isFree = json['is_free'] as bool?,
        mediaBaseUrl = json['media_base_url'] as String?,
        offerId = json['offer_id'] as int?,
        offerName = json['offer_name'] as String?,
        offerTypeId = json['offer_type_id'] as int?,
        platformId = (json['platform_id'] as List?)?.map((dynamic e) => e as int).toList(),
        priceIdr = json['price_idr'] as String?,
        pricePoint = json['price_point'] as int?,
        priceUsd = json['price_usd'] as String?;

  Map<String, dynamic> toJson() => {
    'colors' : colors,
    'discount_id' : discountId,
    'discount_name' : discountName,
    'discount_paymentgateway_id' : discountPaymentgatewayId,
    'discount_price_idr' : discountPriceIdr,
    'discount_price_point' : discountPricePoint,
    'discount_price_usd' : discountPriceUsd,
    'discount_tag' : discountTag,
    'image_highres' : imageHighres,
    'image_normal' : imageNormal,
    'is_discount' : isDiscount,
    'is_free' : isFree,
    'media_base_url' : mediaBaseUrl,
    'offer_id' : offerId,
    'offer_name' : offerName,
    'offer_type_id' : offerTypeId,
    'platform_id' : platformId,
    'price_idr' : priceIdr,
    'price_point' : pricePoint,
    'price_usd' : priceUsd
  };
}

class ItemType {
  final int? id;
  final String? name;

  ItemType({
    this.id,
    this.name,
  });

  ItemType.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name
  };
}

class Languages {
  final int? id;
  final String? name;

  Languages({
    this.id,
    this.name,
  });

  Languages.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name
  };
}

class Vendor {
  final int? id;
  final String? name;
  final String? slug;

  Vendor({
    this.id,
    this.name,
    this.slug,
  });

  Vendor.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        slug = json['slug'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'slug' : slug
  };
}

class Metadata {
  final Resultset? resultset;

  Metadata({
    this.resultset,
  });

  Metadata.fromJson(Map<String, dynamic> json)
      : resultset = (json['resultset'] as Map<String,dynamic>?) != null ? Resultset.fromJson(json['resultset'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'resultset' : resultset?.toJson()
  };
}

class Resultset {
  final int? count;
  final int? limit;
  final int? offset;

  Resultset({
    this.count,
    this.limit,
    this.offset,
  });

  Resultset.fromJson(Map<String, dynamic> json)
      : count = json['count'] as int?,
        limit = json['limit'] as int?,
        offset = json['offset'] as int?;

  Map<String, dynamic> toJson() => {
    'count' : count,
    'limit' : limit,
    'offset' : offset
  };
}