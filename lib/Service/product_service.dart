import 'dart:convert';
import 'dart:developer';

import 'dart:io' as io;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/catalog_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/borrowed_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/borrowed_response_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/organization_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/watch_item_model.dart';
import 'package:revamp_eperpus_mobile/model/ProductKey.dart';
import 'package:revamp_eperpus_mobile/model/recommended_product_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/CatalogesDataModel.dart';
import '../model/Product/Category/GetCatalogInformationModel.dart';
import '../model/file_product.dart';
import '../model/popular_product_item_response.dart';

class ProductService {
  int progress = 0;
  int totalBar = 0;
  SharedPreferences? sharedPreferences;

  var client = http.Client();
  final Dio dio = Dio();

  Future<List<LibraryProductModel>> productList({
    required String queryString,
    int? organizationId,
    int? catalogId,
    int offset = 0,
    int limit = 20,
  }) async {
    final int _organizationId =
        organizationId ?? ApiClient.instance.baseOrganizationId;
    final int _catalogId = catalogId ?? ApiClient.instance.baseCatalogId;
    final String url =
        "${ApiClient.instance.baseUrl}/organizations/$_organizationId/shared-catalogs/"
        "$_catalogId?q=$queryString&available=true&offset=$offset&limit=$limit";

    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {'Authorization': token!};
    var response = await http.get(Uri.parse(url), headers: header);

    if (response.statusCode == 200) {
      await debugLog(response.body);
      List data = jsonDecode(response.body)["items"];
      List<LibraryProductModel> model = [];
      for (var item in data) {
        var dataModel = LibraryProductModel.fromJson(item);
        model.add(dataModel);
      }
      return model;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await debugLog(response.body);
      throw "401";
    } else {
      throw "productList Failed to get data";
    }
  }

  Future<FileProduct> isBorrowed(String title) async {
    final String url =
        "${ApiClient.instance.baseUrl}users/current-user/borrowed-items";
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {
      'Authorization': token!,
    };
    var response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)["items"];
      List<BorrowedBookModel> items = [];
      for (var item in data) {
        items.add(BorrowedBookModel.fromJson(item as Map<String, dynamic>));
      }
      var result = items.where((element) => element.title == title).toList();
      if (result.isEmpty) {
        return FileProduct(fileType: "", url: "Belum minjam buku");
      } else {
        return FileProduct(
          fileType: items[0].fileType,
          url: items[0].urlDownload,
          borrowedId: result.first.id,
          id: result.first.details.id ?? 0,
          expires: result.first.expires,
        );
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw "Force logout";
    } else {
      throw "isBorrowed(String title) Error dalam pencarian";
    }
  }

  Future<DetailProductModel> detail(String url) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var userAgent = sharedPreferences!.getString("userAgent");
    var header = {
      "Content-Type": "application/json",
      'Authorization': token!,
      // "User-Agent": "${ApiClient.instance.userAgent}"
      "User-Agent": userAgent!
    };
    print("User Token: $token");
    var response = await http.get(Uri.parse(url), headers: header);
    //var response = await Dio().get(url, options: Options(headers: header));
    if (response.statusCode == 200) {
      await debugLog("detail product success");
      var modelList = DetailProductModel.fromJson(jsonDecode(response.body));
      return modelList;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await debugLog(response.body);
      throw "Force logout";
    } else {
      throw "Error get detail data";
    }
  }

  Future<ItemInfoModel> detailItem(String url) async {
    await debugLog("run detailItem");
    try {
      final response = await ApiClient.instance.getDataDio(
        url,
        '',
      );
      if (response.statusCode == 200) {
        debugLog("content type value ${response.data!["content_type"]}");
        return ItemInfoModel.fromJson(response.data);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await debugLog(response.data.toString());
        throw "Force logout";
      } else {
        return ItemInfoModel();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return ItemInfoModel();
  }

  Future<List<RecomendationItem>> getRecommendationsBook(int id) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {"Content-Type": "application/json", 'Authorization': token!};
    var response = await http.get(
        Uri.parse("${ApiClient.instance.baseUrl}items/$id/recommendations"),
        headers: header);
    await debugLog(response.toString());
    if (response.statusCode == 200) {
      List model = jsonDecode(response.body)["items"];
      List<RecomendationItem> items = [];
      for (var item in model) {
        items.add(RecomendationItem.fromJson(item));
      }
      return items;
    } else {
      throw "Error get recommendation book";
    }
  }

  LibraryProductModel? borrowedDetail;
  Future<LibraryProductModel?> getBorrowedDetail(String url) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences!.getString("JWT");
      var header = {
        "Content-Type": "application/json",
        'Authorization': token!,
      };
      var response = await http.get(
        Uri.parse(url),
        headers: header,
      );
      await debugLog('response.body: ${response.body}');
      if (response.statusCode == 200) {
        borrowedDetail =
            LibraryProductModel.fromJson(jsonDecode(response.body));
        return borrowedDetail!;
      } else {
        return null;
      }
    } catch (e) {
      await debugLog("Error getRecommendationsDetail: $e");
    }
  }

  LibraryProductModel? recommendationDetail;
  Future<LibraryProductModel?> getRecommendationsDetail(int id) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {"Content-Type": "application/json", 'Authorization': token!};
    var response = await http.get(
      Uri.parse(
          "${ApiClient.instance.baseUrl}organizations/ApiClient.instance.baseOrganizationId/shared-catalogs/${ApiClient.instance.baseCatalogId}/$id"),
      headers: header,
    );
    await debugLog('response.statusCode: ${response.statusCode}');
    // await debugLog('response.body: ${response.body}');
    if (response.statusCode == 200) {
      recommendationDetail =
          LibraryProductModel.fromJson(jsonDecode(response.body));
      // await debugLog(recommendationDetail);
      return recommendationDetail!;
    } else {
      return null;
    }
  }

  Future<List<PopularBookItem>> getPopularBookResponse(int id) async {
    await debugLog('getPopularBookResponse');
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {'Authorization': token!};
    var response = await http.get(
        Uri.parse('${ApiClient.instance.baseUrl}items/popular'),
        headers: header);
    await debugLog(response.toString());
    if (response.statusCode == 200) {
      List model = jsonDecode(response.body)["items"];
      List<PopularBookItem> items = [];
      for (var item in model) {
        items.add(PopularBookItem.fromJson(item));
      }
      return items;
    } else {
      throw "Error get popular book";
    }
  }

  Future<List<BorrowedBookModel>> getBorrowList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var userAgent = sharedPreferences!.getString("userAgent");
    var header = {'Authorization': token!, 'User-Agent': userAgent!};
    var url = "${ApiClient.instance.baseUrl}users/current-user/borrowed-items";
    try {
      var response = await client.get(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)["items"];
        List<BorrowedBookModel> models = [];
        var index = 0;
        while (index < data.length) {
          models.add(BorrowedBookModel.fromJson(data[index]));
          index++;
        }
        return models;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await debugLog(response.body);
        throw "Force logout";
      } else {
        throw "Error get data, empty";
      }
    } catch (e) {
      throw "$e";
    }
  }

  Future<List<WatchItemModel>> getWatchItemList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {'Authorization': token!};
    var url = "${ApiClient.instance.baseUrl}users/current-user/watch-list";
    print("getWatchItemList start");
    var response = await http.get(Uri.parse(url), headers: header);
    print(response.body);
    print("getWatchItemList end");
    if (response.statusCode == 200) {
      await debugLog("Data watch${response.body}");
      List data = jsonDecode(response.body)["items"];
      List<WatchItemModel> models = [];
      var index = 0;
      while (index < data.length) {
        models.add(WatchItemModel.fromJson(data[index]));
        index++;
      }

      return models;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await debugLog(response.body);
      throw "Force logout";
    } else {
      throw "Error get data, empty";
    }
  }

  Future<String> watch(ItemInfoModel data) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {
      "Content-Type": "application/json",
      'Authorization': token!,
    };
    var url =
        Uri.parse("${ApiClient.instance.baseUrl}users/current-user/watch-list");
    //Map<String, dynamic> body = data.toJson();
    var bodyEncode = jsonEncode({
      'id': data.id,
      'rating': data.rating?.toJson(),
      'vendor': data.vendor?.toJson(),
      'user_id': data.userId,
      'total_in_collection': data.totalInCollection,
      'subtitle': data.subtitle,
      'title': data.title,
      'new_title': data.newTitle,
      'new_subtitle': data.newSubtitle,
      'max_borrow_time': data.maxBorrowTime,
      'item_type': data.itemType,
      'is_owned_by_organization': data.isOwnedByOrganization,
      'file_size': data.fileSize,
      'href': data.href,
      'details': data.details?.toJson(),
      'description': data.description,
      'currently_available': data.currentlyAvailable,
      'cover_image': data.coverImage?.toJson(),
      'count_user_id': data.countUserId,
      'borrow_item': data.borrowItem?.toJson(),
      //'previews':previews,
      'page_count': data.pageCount,
      'categories_of_item': data.categoriesOfItem
    });
    var response = await http.post(url, headers: header, body: bodyEncode);
    if (response.statusCode == 201) {
      return "Mohon Ditunggu buku peminjaman lainnya";
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await debugLog(response.body);
      throw "Force logout";
    } else {
      throw "${jsonDecode(response.body)["user_message"]}";
    }
  }

  Future<BorrowedResponseModel> borrow(ItemInfoModel data) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var url = Uri.parse(
        "${ApiClient.instance.baseUrl}users/current-user/borrowed-items");
    var header = {"Authorization": token!, "Content-Type": "application/json"};
    //Map<String, dynamic> body = data.toJson();
    var bodyEncode = jsonEncode({
      'id': data.id,
      'rating': data.rating?.toJson(),
      'vendor': data.vendor?.toJson(),
      'user_id': data.userId,
      'total_in_collection': data.totalInCollection,
      'subtitle': data.subtitle,
      'title': data.title,
      'new_title': data.newTitle,
      'new_subtitle': data.newSubtitle,
      'max_borrow_time': data.maxBorrowTime,
      'item_type': data.itemType,
      'is_owned_by_organization': data.isOwnedByOrganization,
      'file_size': data.fileSize,
      'href': data.href,
      'details': data.details?.toJson(),
      'description': data.description,
      'currently_available': data.currentlyAvailable,
      'cover_image': data.coverImage?.toJson(),
      'count_user_id': data.countUserId,
      'borrow_item': data.borrowItem?.toJson(),
      'page_count': data.pageCount,
      'categories_of_item': data.categoriesOfItem
    });
    var response = await http.post(url, headers: header, body: bodyEncode);
    print("Future<BorrowedResponseModel> url: ${url}");
    print("Future<BorrowedResponseModel> headers: ${header}");
    print("Future<BorrowedResponseModel> borrow: ${response.body}");
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return BorrowedResponseModel.fromJson(data);
    } else {
      throw "${jsonDecode(response.body)["user_message"]}";
    }
  }

  Future<String> returnBorrowed(int productId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {"Authorization": token!, "Content-Type": "application/json"};
    var url =
        "${ApiClient.instance.baseUrl}users/current-user/borrowed-items/$productId";
    var response = await Dio().delete(url, options: Options(headers: header));
    if (response.statusCode == 200) {
      return "Success mengembalikan  buku";
    } else {
      throw "Error Mengembalikan buku";
    }
  }

  Future<String> deleteWatch(String link) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {"Authorization": token!};
    var url = Uri.parse(link);

    var response = await http.delete(url, headers: header);
    await debugLog(response.toString());
    if (response.statusCode == 204) {
      return "Success menghapus antrian  buku";
    } else {
      throw "Error menghapus antrian buku";
    }
  }

  Future<String> getBookKeyMeta(int bookId) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences!.getString("JWT");
      var url = "${ApiClient.instance.baseUrl}items/$bookId/download/meta";
      var header = {"Authorization": token!};
      var response = await http.get(Uri.parse(url), headers: header);
      await debugLog(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        await debugLog("getBookKeyMeta: $data");
        return data['key'];
      } else {
        throw "Error get data, empty";
      }
    } catch (e) {
      await debugLog("Error getBookKeyMeta: $e");
      throw "Error $e";
    }
  }

  Future<GetCatalogInformationModel?> getCategory(
      String href, String catalogTitle) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var userAgent = sharedPreferences!.getString("userAgent");

    final String url = "$href?offset=0&limit=0&available=false";
    var header = {
      "Authorization": token!,
      // "User-Agent": "${ApiClient.instance.userAgent}"
      "User-Agent": userAgent!
    };
    print("Get Category: $url");

    var response = await http.get(Uri.parse(url), headers: header);
    await debugLog(response.body);
    if (response.statusCode == 200) {
      await debugLog(response.toString());
      var data = GetCatalogInformationModel.mapJson(jsonDecode(response.body));
      return data;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      await debugLog(response.body);
      throw "Force logout";
    } else {
      return null;
    }
  }

  Future<List<LibraryProductModel>> getCategoryBooks({
    int? organizationId,
    int? catalogId,
    required String category,
    int offset = 0,
    int limit = 20,
  }) async {
    print("API GET: getCategoryBooks");
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");
    var header = {"Content-Type": "application/json", 'Authorization': token!};
    final int _organizationId =
        organizationId ?? ApiClient.instance.baseOrganizationId;
    final int _catalogId = catalogId ?? ApiClient.instance.baseCatalogId;
    var urlEncoded = Uri.encodeComponent("category_names:$category");
    final String url =
        "${ApiClient.instance.baseUrl}organizations/$_organizationId/shared-catalogs/$_catalogId?facets=$urlEncoded&offset=$offset&limit=$limit";

    var response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)["items"];
      List<LibraryProductModel> model = [];
      for (var item in data) {
        var dataModel = LibraryProductModel.fromJson(item);
        model.add(dataModel);
      }
      return model;
    } else {
      throw "Error";
    }
  }

  Future<Organization?> getOrganization(int? organizationId) async {
    try {
      await debugLog("getOrganization");
      final sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString("JWT");
      var url =
          "${ApiClient.instance.baseUrl}organizations/${organizationId ?? ApiClient.instance.baseOrganizationId}";
      var header = {"Authorization": token!};
      var response = await http.get(Uri.parse(url), headers: header);
      await debugLog(response.body);
      if (response.statusCode == 200) {
        final Organization data =
            Organization.fromJson(jsonDecode(response.body));
        return data;
      } else {
        throw "Error get data, empty";
      }
    } catch (e) {
      await debugLog("Error catch: $e");
    }
    return null;
  }

  Future<Organization?> getOrganizationProfile() async {
    try {
      await debugLog("getOrganizationProfile");
      final sharedPreferences = await SharedPreferences.getInstance();
      final String? token = sharedPreferences.getString("JWT");
      final String? url = await getOrgUrl();
      var header = {"Authorization": token!};
      var response = await http.get(Uri.parse(url!), headers: header);
      await debugLog(response.body);
      if (response.statusCode == 200) {
        final Organization data =
            Organization.fromJson(jsonDecode(response.body));
        return data;
      } else {
        throw "Error get data, empty";
      }
    } catch (e) {
      await debugLog("Error catch: $e");
    }
    return null;
  }

  String getParameterUrl({
    String href = '',
    String parameter = '',
    String? category = '',
    bool? isAscending,
    int? offset = 0,
    int? limit = 20,
    String? queryEncode,
    String? urlEncoded,
  }) {
    String url = href;

    if (category == "All Categories" || category == null || category == "") {
      url = "$href?q=$queryEncode&offset=$offset&limit=$limit";
    } else {
      url =
          "$href?q=$queryEncode&facets=$urlEncoded&offset=$offset&limit=$limit";
    }
    if (isAscending != null) {
      String sortMode = isAscending ? 'asc' : 'desc';
      url = "$url&sort=item_release_date $sortMode";
    }
    return url;
  }

  String queryEncode = "";
  String urlEncoded = "";
  bool? _isAscending;
  Future<List<LibraryProductModel>> getProductsByCatalog({
    required String href,
    required String queryString,
    String? category,
    bool? isAscending,
    int offset = 0,
    int limit = 20,
  }) async {
    print("API GET: getProductsByCatalog");
    _isAscending = isAscending;
    final String queryEncode = Uri.encodeComponent(queryString);
    final String urlEncoded = Uri.encodeComponent("category_names:$category");
    final String requestUrl = getParameterUrl(
      href: href,
      queryEncode: queryEncode,
      category: category,
      urlEncoded: urlEncoded,
      isAscending: _isAscending,
      offset: offset,
      limit: limit,
    );
    try {
      var response = await ApiClient.instance.getData(
        requestUrl,
        '',
      );

      if (response.statusCode == 200) {
        await debugLog(response.toString());
        List resBooks = jsonDecode(response.body)["items"];
        List<LibraryProductModel> listOfBooks = [];
        for (var item in resBooks) {
          var dataModel = LibraryProductModel.fromJson(item);
          listOfBooks.add(dataModel);
        }
        return listOfBooks;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await debugLog(jsonDecode(response.body).toString());
        throw "Force logout";
      } else {
        throw "getProductsByCatalog Failed to get data";
      }
    } catch (e) {
      print("Get Books Error: $e");
      throw e.toString();
    } finally {
      client.close();
    }
  }

  Future<List<Catalog>?> getCatalogSubs() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString("JWT");
      var url =
          "${ApiClient.instance.baseUrl}users/current-user/subscribed-catalogs";
      var header = {"Authorization": token!};
      var response = await http.get(Uri.parse(url), headers: header);
      await debugLog(response.body);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)["catalogs"];
        List<Catalog> items = [];

        for (var item in data) {
          items.add(Catalog.fromJson(item as Map<String, dynamic>));
        }
        return items;
      } else {
        throw "Error get data, empty";
      }
    } catch (e) {
      await debugLog("Error catch: $e");
    }
    return null;
  }

  Future<GetCatalogInformationModel?> getCategoryCatalog(String href) async {
    // final int _organizationId =
    //     organizationId ?? ApiClient.instance.baseOrganizationId;
    // final int _catalogId = catalogId ?? ApiClient.instance.baseCatalogId;
    final String url = "$href?offset=0&limit=0&available=false";
    var response = await Dio().get(url);
    if (response.statusCode == 200) {
      await debugLog(response.statusCode as String);
      var data = GetCatalogInformationModel.mapJson(response.data);
      return data;
    } else {
      return null;
    }
  }

  Future<List<LibraryProductModel>> getCategoryBooksCatalog({
    int? organizationId,
    int? catalogId,
    required String href,
    required String category,
    required String query,
    int offset = 0,
    int limit = 20,
  }) async {
    print("API GET: getCategoryBooksCatalog");
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("JWT");

    var header = {"Content-Type": "application/json", 'Authorization': token!};

    var urlEncoded = Uri.encodeComponent("category_names:$category");
    var queryParams = Uri.encodeComponent("q=$query");
    final String url =
        "$href?$queryParams&facets=$urlEncoded&offset=$offset&limit=$limit";

    var response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)["items"];
      List<LibraryProductModel> model = [];
      for (var item in data) {
        var dataModel = LibraryProductModel.fromJson(item);
        model.add(dataModel);
      }
      return model;
    } else {
      throw "Error";
    }
  }

  Future<CatalogesDataModel> getCatalogs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var url =
        "${ApiClient.instance.baseUrl}users/current-user/subscribed-catalogs";
    var token = sharedPreferences.getString("JWT");
    var userAgent = sharedPreferences.getString("userAgent");
    var header = {'Authorization': token!, 'User-Agent': userAgent!};
    try {
      var response = await client.get(Uri.parse(url), headers: header);
      print("getCatalogs headers: $header");
      print("getCatalogs Get Catalog: ${response.body}");
      print("getCatalogs response status code: ${response.statusCode}");
      await debugLog(response.body);
      if (response.statusCode == 200) {
        final CatalogesDataModel data =
            CatalogesDataModel.fromJson(jsonDecode(response.body));
        return data;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // await debugLog(response.body);
        throw "401";
      } else {
        throw "Error get data, empty";
      }
    } catch (e) {
      print("getCatalogs Catalog error: $e");
      throw e;
    } finally {
      client.close();
    }
  }

  Future<ProductKey> getKey(int id) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("JWT");
    var header = {'Authorization': token!};
    var url = Uri.parse("${ApiClient.instance.baseUrl}items/$id/download/meta");
    var response = await http.get(url, headers: header);
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      ProductKey data = ProductKey.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw "getKey(int id): Error dalam pencarian";
    }
  }
}
