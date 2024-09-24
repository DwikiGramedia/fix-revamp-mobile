// To parse this JSON data, do
//
//     final popularBookResponse = popularBookResponseFromJson(jsonString);

import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:revamp_eperpus_mobile/model/popular_book_response.dart';

class PopularBookResponse {
  PopularBookResponse({
    required this.items,
    required this.metadata,
  });

  List<PopularBookItem> items;
  Metadata metadata;

  factory PopularBookResponse.fromJson(Map<String, dynamic> json) =>
      PopularBookResponse(
        items: List<PopularBookItem>.from(
            json["items"].map((x) => PopularBookItem.fromJson(x))),
        metadata: Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "metadata": metadata.toJson(),
      };
}

class PopularBookItem {
  PopularBookItem({
    required this.authors,
    required this.brand,
    required this.categories,
    required this.contentType,
    required this.displayOffers,
    required this.id,
    required this.isBuffet,
    required this.isLatest,
    required this.issueNumber,
    required this.itemThumbHighres,
    required this.itemTypeId,
    required this.mediaBaseUrl,
    required this.name,
    required this.parentalControl,
    required this.slug,
    required this.thumbImageHighres,
    required this.thumbImageNormal,
    required this.vendor,
  });

  List<Brand> authors;
  Brand brand;
  List<ParentalControl> categories;
  int contentType;
  List<DisplayOffer> displayOffers;
  int id;
  bool isBuffet;
  bool isLatest;
  String issueNumber;
  String itemThumbHighres;
  int itemTypeId;
  String mediaBaseUrl;
  String name;
  ParentalControl parentalControl;
  String slug;
  String thumbImageHighres;
  String thumbImageNormal;
  ParentalControl vendor;

  factory PopularBookItem.fromJson(Map<String, dynamic> json) =>
      PopularBookItem(
        authors: getJsonListValue(json, 'authors')
            .map<Brand>((dynamic value) => Brand.fromJson(value))
            .toList(),
        brand: Brand.fromJson(getJsonValueAsJson(json, 'brand')),
        categories: getJsonListValue(json, 'categories')
            .map<ParentalControl>(
              (dynamic value) => ParentalControl.fromJson(value),
            )
            .toList(),
        contentType: getJsonValueAsInt(json, 'content_type'),
        displayOffers: [],
        id: getJsonValueAsInt(json, 'id'),
        isBuffet: getJsonValueAsBool(json, 'is_buffet'),
        isLatest: getJsonValueAsBool(json, 'is_latest'),
        issueNumber: getJsonValueAsString(json, 'issue_number'),
        itemThumbHighres: getJsonValueAsString(json, 'item_thumb_highres'),
        itemTypeId: getJsonValueAsInt(json, 'item_type_id'),
        mediaBaseUrl: getJsonValueAsString(json, 'media_base_url'),
        name: getJsonValueAsString(json, 'name'),
        parentalControl: ParentalControl.fromJson(
          getJsonValueAsJson(json, 'parental_control'),
        ),
        slug: getJsonValueAsString(json, 'slug'),
        thumbImageHighres: getJsonValueAsString(json, 'thumb_image_highres'),
        thumbImageNormal: getJsonValueAsString(json, 'thumb_image_normal'),
        vendor: ParentalControl.fromJson(getJsonValueAsJson(json, 'vendor')),
      );

  Map<String, dynamic> toJson() => {
        "authors": List<dynamic>.from(authors.map((x) => x.toJson())),
        "brand": brand.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "content_type": contentType,
        "display_offers":
            List<dynamic>.from(displayOffers.map((x) => x.toJson())),
        "id": id,
        "is_buffet": isBuffet,
        "is_latest": isLatest,
        "issue_number": issueNumber,
        "item_thumb_highres": itemThumbHighres,
        "item_type_id": itemTypeId,
        "media_base_url": mediaBaseUrl,
        "name": name,
        "parental_control": parentalControl.toJson(),
        "slug": slug,
        "thumb_image_highres": thumbImageHighres,
        "thumb_image_normal": thumbImageNormal,
        "vendor": vendor.toJson(),
      };
}

class Brand {
  Brand({
    required this.id,
    required this.name,
    required this.slug,
  });

  int id;
  String name;
  String slug;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}

class ParentalControl {
  ParentalControl({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory ParentalControl.fromJson(Map<String, dynamic> json) =>
      ParentalControl(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class DisplayOffer {
  DisplayOffer({
    //required this.colors,
    // required this.imageHighres,
    // required this.imageNormal,
    required this.isFree,
    required this.mediaBaseUrl,
    required this.offerId,
    required this.offerName,
    required this.offerTypeId,
    required this.platformId,
    required this.priceIdr,
    required this.pricePoint,
    required this.priceUsd,
    required this.discountId,
    required this.discountName,
    required this.discountPaymentgatewayId,
    required this.discountPriceIdr,
    required this.discountPricePoint,
    required this.discountPriceUsd,
    required this.discountTag,
    required this.isDiscount,
  });

  //Colors colors;
  // Image? imageHighres;
  // Image? imageNormal;
  bool isFree;
  String mediaBaseUrl;
  int offerId;
  String offerName;
  int offerTypeId;
  List<int> platformId;
  String priceIdr;
  int pricePoint;
  String priceUsd;
  List<int>? discountId;
  String discountName;
  List<int>? discountPaymentgatewayId;
  String discountPriceIdr;
  int discountPricePoint;
  String discountPriceUsd;
  String discountTag;
  bool isDiscount;

  factory DisplayOffer.fromJson(Map<String, dynamic> json) => DisplayOffer(
        //colors: json["colors"] == null ? null : Colors.fromJson(json["colors"]),
        // imageHighres: json["image_highres"] == null ? null : imageValues.map[json["image_highres"]],
        // imageNormal: json["image_normal"] == null ? null : imageValues.map[json["image_normal"]],
        isFree: json["is_free"],
        mediaBaseUrl: json["media_base_url"],
        offerId: json["offer_id"],
        offerName: json["offer_name"],
        offerTypeId: json["offer_type_id"],
        platformId: List<int>.from(json["platform_id"].map((x) => x)),
        priceIdr: json["price_idr"],
        pricePoint: json["price_point"],
        priceUsd: json["price_usd"],
        discountId: json["discount_id"] == null
            ? null
            : List<int>.from(json["discount_id"].map((x) => x)),
        discountName:
            json["discount_name"] == null ? null : json["discount_name"],
        discountPaymentgatewayId: json["discount_paymentgateway_id"] == null
            ? null
            : List<int>.from(json["discount_paymentgateway_id"].map((x) => x)),
        discountPriceIdr: json["discount_price_idr"] == null
            ? null
            : json["discount_price_idr"],
        discountPricePoint: json["discount_price_point"] == null
            ? null
            : json["discount_price_point"],
        discountPriceUsd: json["discount_price_usd"] == null
            ? null
            : json["discount_price_usd"],
        discountTag: json["discount_tag"] == null ? null : json["discount_tag"],
        isDiscount: json["is_discount"] == null ? null : json["is_discount"],
      );

  Map<String, dynamic> toJson() => {
        //"colors": colors == null ? null : colors.toJson(),
        // "image_highres": imageHighres == null ? null : imageValues.reverse[imageHighres],
        // "image_normal": imageNormal == null ? null : imageValues.reverse[imageNormal],
        "is_free": isFree,
        "media_base_url": mediaBaseUrl,
        "offer_id": offerId,
        "offer_name": offerName,
        "offer_type_id": offerTypeId,
        "platform_id": List<dynamic>.from(platformId.map((x) => x)),
        "price_idr": priceIdr,
        "price_point": pricePoint,
        "price_usd": priceUsd,
        "discount_id": discountId == null
            ? null
            : List<dynamic>.from(discountId!.map((x) => x)),
        "discount_name": discountName == null ? null : discountName,
        "discount_paymentgateway_id": discountPaymentgatewayId == null
            ? null
            : List<dynamic>.from(discountPaymentgatewayId!.map((x) => x)),
        "discount_price_idr":
            discountPriceIdr == null ? null : discountPriceIdr,
        "discount_price_point":
            discountPricePoint == null ? null : discountPricePoint,
        "discount_price_usd":
            discountPriceUsd == null ? null : discountPriceUsd,
        "discount_tag": discountTag == null ? null : discountTag,
        "is_discount": isDiscount == null ? null : isDiscount,
      };
}

// class Colors {
//   Colors({
//     required this.backgroundHex, @required this.backgroundOpacity,
//     @required this.backgroundRgba,
//     @required this.borderHex,
//     @required this.borderRgba,
//     @required this.textHex,
//     @required this.textRgba,
//   });
//
//   BackgroundHex backgroundHex;
//   String backgroundOpacity;
//   List<int> backgroundRgba;
//   Hex borderHex;
//   List<int> borderRgba;
//   Hex textHex;
//   List<int> textRgba;
//
//   factory Colors.fromJson(Map<String, dynamic> json) => Colors(
//     backgroundHex: backgroundHexValues.map[json["background_hex"]],
//     backgroundOpacity: json["background_opacity"],
//     backgroundRgba: List<int>.from(json["background_rgba"].map((x) => x)),
//     borderHex: hexValues.map[json["border_hex"]],
//     borderRgba: List<int>.from(json["border_rgba"].map((x) => x)),
//     textHex: hexValues.map[json["text_hex"]],
//     textRgba: List<int>.from(json["text_rgba"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "background_hex": backgroundHexValues.reverse[backgroundHex],
//     "background_opacity": backgroundOpacity,
//     "background_rgba": List<dynamic>.from(backgroundRgba.map((x) => x)),
//     "border_hex": hexValues.reverse[borderHex],
//     "border_rgba": List<dynamic>.from(borderRgba.map((x) => x)),
//     "text_hex": hexValues.reverse[textHex],
//     "text_rgba": List<dynamic>.from(textRgba.map((x) => x)),
//   };
// }

enum BackgroundHex { D1_B65_F }
//
// final backgroundHexValues = EnumValues({
//   "#D1B65F": BackgroundHex.D1_B65_F
// });
//
// enum Hex { THE_7_F7042 }
//
// final hexValues = EnumValues({
//   "#7F7042": Hex.THE_7_F7042
// });
//
// enum Image { OFFERS_ID_SCOOPPREMIUM_PNG, EMPTY }
//
// final imageValues = EnumValues({
//   "": Image.EMPTY,
//   "offers/ID_SCOOPPREMIUM.png": Image.OFFERS_ID_SCOOPPREMIUM_PNG
// });
