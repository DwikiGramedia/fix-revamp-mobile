// Generated; built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-27 10:08:59
// @modify date 2022-03-30 02:38:24
// @desc Product Object
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-27 10:08:59

import 'package:revamp_eperpus_mobile/model/author_data.dart';
import 'package:revamp_eperpus_mobile/model/organization_data.dart';

class ProductData {
  int id = 0;
  String title = '';
  String subtitle = '';
  String vendorTitle = '';
  String itemType = '';
  String coverImageHref = '';
  int pageCount = 0;
  double ratingAverage = 0.0;
  int ratingTotal = 0;
  String editionCode = '';

  int organizationId = 0;
  bool isOwnedByOrganization = false;
  OrganizationsCatalog catalog = OrganizationsCatalog();

  String description = '';
  String detailsHref = '';

  String fileSize = '';

  //List<ProductCategory> categories = <ProductCategory>[];

  int currentlyAvailable = 0;
  int totalInCollection = 0;

  String maxBorrowTime = '';
  String borrowItemHref = '';

  List<String> previews = <String>[];
  List<AuthorData> authors = <AuthorData>[];

  String nextAvailable = '';
  bool reviewStatus = false;
  String watchList = 'null';

  ProductData();

  ProductData.fromJson(Map<String, dynamic> json)
      : id = json['id'] == null ? 0 : json['id'] as int,
        title = json['new_title'] == null ? '' : json['new_title'] as String,
        subtitle =
            json['new_subtitle'] == null ? '' : json['new_subtitle'] as String,
        vendorTitle = json['vendor']['title'] == null
            ? ''
            : json['vendor']['title'] as String,
        itemType = json['item_type'] == null ? '' : json['item_type'] as String,
        coverImageHref = json['cover_image']['href'] == null
            ? ''
            : json['cover_image']['href'] as String,
        pageCount = json['page_count'] == null ? 0 : json['page_count'] as int,
        ratingAverage = json['rating']['average'] == null
            ? 0
            : json['rating']['average'] as double,
        ratingTotal = json['rating']['total'] == null
            ? 0
            : json['rating']['total'] as int,
        organizationId = json['organization_id'] == null
            ? 0
            : json['organization_id'] as int,
        editionCode =
            json['edition_code'] == null ? '' : json['edition_code'] as String,
        isOwnedByOrganization = json['is_owned_by_organization'] == null
            ? false
            : json['is_owned_by_organization'] as bool,
        description =
            json['description'] == null ? '' : json['description'] as String,
        detailsHref = json['href'] == null ? '' : json['href'] as String,
        fileSize = json['file_size'] == null ? '' : json['file_size'] as String,
        currentlyAvailable = json['currently_available'] == null
            ? 0
            : json['currently_available'] as int,
        totalInCollection = json['total_in_collection'] == null
            ? 0
            : json['total_in_collection'] as int,
        maxBorrowTime = json['max_borrow_time'] == null
            ? ''
            : json['max_borrow_time'] as String,
        borrowItemHref = json['borrow_item']['href'] == null
            ? ''
            : json['borrow_item']['href'] as String,
        previews = json['previews'] == null
            ? [json['cover_image']['href']]
            : previewJsonArray(json['previews']);

  List<ProductData> fromJsonArray(List<dynamic> data) {
    return data.map((datum) => ProductData.fromJson(datum)).toList();
  }

  static List<String> previewJsonArray(List<dynamic> data) {
    return data.map((datum) => datum['href'].toString()).toList();
  }
  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'new_title':title,
      'new_subtitle':subtitle,
      'item_type':itemType,
      'page_count':pageCount,
      'organization_id':organizationId,
      'href':detailsHref,
      'description':description,
      'file_size':fileSize,
      'currently_available':currentlyAvailable,
      'max_borrow_time':maxBorrowTime,
      'total_in_collection':totalInCollection,
      'edition_code':editionCode,
      'is_owned_by_organization':isOwnedByOrganization,

    };
  }
}


/**
            "categories_of_item": "Business & Investing",
            "count_user_id": 0,
            "cover_image": {
                "href": "https://s3-ap-southeast-1.amazonaws.com/ebook-covers/36300/general_covers/ID_GPU2017MTH03ESER_C.jpg",
                "title": "Gambar Sampul"
            },
            "currently_available": 2,
            "description": "Menurut CNBC, ada 10 penyebab umum kebangkrutan bisnis, dan salah satunya adalah kebangkrutan karena kualitas pelayanan. Menurut data, hingga 66% konsumen beralih ke perusahaan baru karena kualitas pelayanan, sementara hanya 4% pelanggan yang mau bermurah hati menyuarakan masukan untuk perbaikan lewat keluhan. Ironisnya, 80% perusahaan mengklaim telah memberikan pelayanan “superior” kepada pelanggannya.\r\n\r\nKondisi ironis seperti itu merupakan peringatan keras bagi organisasi mana pun. Ada tiga bagian besar tentang service yang akan dibahas dalam buku ini:\r\n• Service leadership\r\n• Service mindset\r\n• Service tools\r\n\r\nSebagai orang yang memiliki pola pikir layanan pelanggan, kita memiliki kewajiban menyadarkan pergeseran kompetisi ke arah pelayanan dan memelopori berbagai perubahan ke arah pelayanan yang lebih baik. Bukankah kita semua tidak ingin tertinggal, punah, dan menjadi sejarah? Untuk itu, mari kita membangun organisasi yang berfokus kepada layanan unggul (excellent service) seperti yang diuraikan secara detail dalam buku ini.",
            "details": {
                "href": APIConstants.instance.baseUrl +"items/126102",
                "id": 126102,
                "title": "Detil Item"
            },
            "file_size": "4.9 MB",
            "href": APIConstants.instance.baseUrl +"organizations/1100769/shared-catalogs/11/126102",
            "id": 126102,
            "is_owned_by_organization": true,
            "item_type": "book",
            "max_borrow_time": "P0Y0M7DT0H0M0S",
            "new_subtitle": "Heria Windasuri",
            "new_title": "Excellent Service",
            "rating": {
                "average": 4.8,
                "total": 144
            },
            "subtitle": "Gramedia Pustaka Utama",
            "title": "Excellent Service",
            "total_in_collection": 2,
            "user_id": null,
            "vendor": {
                "href": APIConstants.instance.baseUrl +"vendors/251",
                "title": "Gramedia Pustaka Utama"
            }
 */



// class ProductData {
//   String coverImage = '';
//   String productName = '';
//   String productFile = '';
//   String authorName = '';

//   int rating = 0;
//   int pages = 0;
//   int stock = 0;
//   String fileSize = '';
//   String overview = '';

//   List<String> preview = [];

//   ProductData();

//   void setInit(strCoverImage; strProductName; strProductFile; strAuthor;
//       intRating; intPages; intStock; strFileSize; strOverview; arrPreview) {
//     coverImage = strCoverImage;
//     productName = strProductName;
//     productFile = strProductFile;
//     authorName = strAuthor;
//     rating = intRating;
//     pages = intPages;
//     stock = intStock;
//     fileSize = strFileSize;
//     overview = strOverview;
//     preview = arrPreview;
//   }

  // ProductData.fromJson(Map<String; dynamic> json)
  //     : coverImage = json['image'] as String;
  //       productName = json['name'] as String;
  //       productFile = json['file'] as String;
  //       authorName = json['author'] as String;
  //       fileSize = json['filesize'] as String;
  //       overview = json['overview'] as String;
  //       rating = json['rating'] as int;
  //       pages = json['pages'] as int;
  //       stock = json['stock'] as int;
  //       preview = previewJsonArray(json['preview']);

//   Map<String; dynamic> toJson() => {
//         'image': coverImage;
//         'name': productName;
//         'file': productFile;
//         'author': authorName
//       };

  // List<ProductData> fromJsonArray(List<dynamic> data) {
  //   return data.map((datum) => ProductData.fromJson(datum)).toList();
  // }

  // static List<String> previewJsonArray(List<dynamic> data) {
  //   return data.map((datum) => datum.toString()).toList();
  // }
// }
