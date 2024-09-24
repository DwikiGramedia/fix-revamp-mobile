import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/catalog_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/catalog_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/details_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/download_model.dart';

import 'PartModel/owner_model.dart';
import 'PartModel/stream_model.dart';
import 'PartModel/vendor_model.dart';

class BorrowedResponseModel {
  BorrowedResponseModel({
    required this.borrowingStartTime,
    required this.catalog,
    required this.catalogItem,
    required this.coverImage,
    required this.currentlyAvailable,
    required this.details,
    required this.download,
    required this.expires,
    required this.fileSize,
    required this.firstName,
    required this.href,
    required this.id,
    required this.lastName,
     this.lastReadPage,
     this.lastReadTime,
    required this.newSubtitle,
    required this.newTitle,
    required this.owner,
    required this.streaming,
    required this.title,
    required this.username,
    required this.vendor,
  });
  late final String borrowingStartTime;
  late final Catalog catalog;
  late final CatalogItem catalogItem;
  late final CoverImage coverImage;
  late final int currentlyAvailable;
  late final Details details;
  late final Download download;
  late final String expires;
  late final String fileSize;
  late final String firstName;
  late final String href;
  late final int id;
  late final String lastName;
  late final Null lastReadPage;
  late final Null lastReadTime;
  late final String newSubtitle;
  late final String newTitle;
  late final Owner owner;
  late final Streaming streaming;
  late final String title;
  late final String username;
  late final Vendor vendor;
  
  BorrowedResponseModel.fromJson(Map<String, dynamic> json){
    borrowingStartTime = json["borrowing_start_time"];
    catalog = Catalog.fromJson(json["catalog"]);
    catalogItem = CatalogItem.fromJson(json["catalog_item"]);
    coverImage = CoverImage.fromJson(json["cover_image"]);
    currentlyAvailable = json["currently_available"];
    details = Details.fromJson(json["details"]);
    download = Download.fromJson(json["download"]);
    expires = getJsonValueAsString(json, "expires");
    fileSize = json["file_size"];
    firstName = json["first_name"];
    href = json["href"];
    id = json["id"];
    lastName = json["last_name"];
    //lastReadPage = null;
    //lastReadTime = null;
    newSubtitle = json["new_subtitle"];
    newTitle = json["new_title"];
    owner = Owner.fromJson(json["owner"]);
    streaming = Streaming.fromJson(json["streaming"]);
    title = json["title"];
    username = json["username"];
    vendor = Vendor.fromJson(json["vendor"]);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['borrowing_start_time'] = borrowingStartTime;
    _data['catalog'] = catalog.toJson();
    _data['catalog_item'] = catalogItem.toJson();
    _data['cover_image'] = coverImage.toJson();
    _data['currently_available'] = currentlyAvailable;
    _data['details'] = details.toJson();
    _data['download'] = download.toJson();
    _data['expires'] = expires;
    _data['file_size'] = fileSize;
    _data['first_name'] = firstName;
    _data['href'] = href;
    _data['id'] = id;
    _data['last_name'] = lastName;
    _data['last_read_page'] = lastReadPage;
    _data['last_read_time'] = lastReadTime;
    _data['new_subtitle'] = newSubtitle;
    _data['new_title'] = newTitle;
    _data['owner'] = owner.toJson();
    _data['streaming'] = streaming.toJson();
    _data['title'] = title;
    _data['username'] = username;
    _data['vendor'] = vendor.toJson();
    return _data;
  }
}
