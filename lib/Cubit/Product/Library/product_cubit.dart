import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Dialog/unauthorized_dialog.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/home_view.dart';
import 'package:revamp_eperpus_mobile/model/CatalogesDataModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  PagingController<int, LibraryProductModel> libraryController =
      PagingController(firstPageKey: 0);
  int contentLimitLibrary = 12;
  int offsetLibrary = 0;
  List<LibraryProductModel> modelLibrary = [];
  bool? isAscending;

  String urlProduct = "";
  int organizationIdSet = 0;
  PagingController<int, LibraryProductModel> collectionController =
      PagingController(firstPageKey: 0);
  int contentLimitCollection = 6;
  int offsetCollection = 0;
  List<LibraryProductModel> modelCollection = [];
  SharedPreferences? sharedPreferences;
  Map<String, dynamic>? sortLabel;

  bool isFirstInit = true;

  void initState() {
    emit(ProductLoading());
    emit(GetListDataProduct(
      modelLibrary: modelLibrary,
      libraryController: libraryController,
      initContentCountLibrary: contentLimitLibrary,
      contentCountLibrary: offsetLibrary,
      isFirstInit: isFirstInit,
      sortLabel: sortLabel,
    ));
  }

  void resetPagination() {
    // libraryController = PagingController(firstPageKey: 0);

    contentLimitLibrary = 6;
    offsetLibrary = 0;
    modelLibrary = [];
  }

  Future<void> getProductList(
    BuildContext context, {
    int? pageKey,
    String? organizationId,
    String? categories,
  }) async {
    try {
      if (isFirstInit) {
        emit(ProductLoading());
        sortLabel = sortLabel ??
            {
              "value": null,
              "sortLabel": "Default",
              "sortDetail": "Default",
            };
        CatalogesDataModel bookCatalogs = await ProductService().getCatalogs();
        if (urlProduct.isEmpty) {
          urlProduct = bookCatalogs.catalogs.first.href ?? "";
          organizationIdSet = bookCatalogs.catalogs.first.id ?? 0;
          await sharedPreferences?.setInt("organizationId", organizationIdSet);
        }
        modelLibrary = await ProductService().getProductsByCatalog(
          href: urlProduct,
          queryString: "",
          offset: offsetLibrary,
          limit: contentLimitLibrary,
          category: categories,
          isAscending: isAscending,
        );

        if (modelLibrary.length < contentLimitLibrary) {
          libraryController.appendLastPage(modelLibrary);
          print("Library Changes");
        } else {
          offsetLibrary = offsetLibrary + contentLimitLibrary;
          final nextPageKey = contentLimitLibrary + modelLibrary.length;
          libraryController.appendPage(modelLibrary, nextPageKey);
          print("Library Changes 2");
        }
        isFirstInit = false;
        emit(
          GetListDataProduct(
            modelLibrary: modelLibrary,
            libraryController: libraryController,
            initContentCountLibrary: contentLimitLibrary,
            contentCountLibrary: offsetLibrary,
            isFirstInit: isFirstInit,
            sortLabel: sortLabel,
          ),
        );
      } else {
        modelLibrary = await ProductService().getProductsByCatalog(
          href: urlProduct,
          queryString: "",
          offset: offsetLibrary,
          limit: contentLimitLibrary,
          category: categories,
          isAscending: isAscending,
        );
        if (modelLibrary.length < contentLimitLibrary) {
          libraryController.appendLastPage(modelLibrary);
          print("Library Changes");
        } else {
          offsetLibrary = offsetLibrary + contentLimitLibrary;
          final nextPageKey = contentLimitLibrary + modelLibrary.length;
          libraryController.appendPage(modelLibrary, nextPageKey);
          print("Library Changes 2");
        }
        isFirstInit = false;
        emit(
          GetListDataProduct(
            modelLibrary: modelLibrary,
            libraryController: libraryController,
            initContentCountLibrary: contentLimitLibrary,
            contentCountLibrary: offsetLibrary,
            isFirstInit: isFirstInit,
            sortLabel: sortLabel,
          ),
        );
      }
    } catch (e) {
      if (e.toString() == "401" || e.toString().contains("Force logout")) {
        emit(UserForceLogout());
      } else {
        emit(GetListDataFailed(error: e.toString()));
      }
    }
  }

  Future<void> onLoading() async {
    emit(ProductLoading());
  }

  String? catalogId;
  String catalogTitle = '';

  void resetProductWithoutURLProduct(BuildContext context, String href,
      String _catalogTitle, String _catalogId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    // libraryController.addPageRequestListener((pageKey) {
    //   getProductList(catalogId: catalogId);
    // });
    libraryController = PagingController(firstPageKey: 0);
    contentLimitLibrary = 6;
    offsetLibrary = 0;
    modelLibrary.clear();
    modelLibrary = [];
    isFirstInit = true;
    //await sharedPreferences?.setString("urlProduct", urlProduct);
    //urlProduct = href;

    //await sharedPreferences?.setInt("organizationId", int.parse(_catalogId!));
    catalogTitle = _catalogTitle;
    //Navigator.popAndPushNamed(context, HomePage.routeName);
  }

  Future<void> resetProductList(BuildContext context, String href,
      String _catalogTitle, String _catalogId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    // libraryController.addPageRequestListener((pageKey) {
    //   getProductList(catalogId: catalogId);
    // });
    libraryController = PagingController(firstPageKey: 0);
    contentLimitLibrary = 6;
    offsetLibrary = 0;
    modelLibrary.clear();
    modelLibrary = [];
    isFirstInit = true;
    //await sharedPreferences?.setString("urlProduct", urlProduct);
    urlProduct = href;

    //await sharedPreferences?.setInt("organizationId", int.parse(_catalogId));
    await debugLog("catalogId = _catalogId before: $catalogId");
    catalogTitle = _catalogTitle;
    Navigator.popAndPushNamed(context, HomePage.routeName);
    await debugLog("catalogId = _catalogId after: $catalogId");
  }

  String categoryTitle = "";

  Future<void> resetProductListByCategory(
      BuildContext context, String _catalogId, String _categoryTitle) async {
    try {
      emit(ProductLoading());
      CatalogesDataModel bookCatalogs = await ProductService().getCatalogs();
      if (urlProduct.isEmpty || _catalogId.isEmpty) {
        urlProduct = bookCatalogs.catalogs.first.href ?? "";
        organizationIdSet = bookCatalogs.catalogs.first.id ?? 0;
        await sharedPreferences?.setInt("organizationId", organizationIdSet);
      }

      libraryController = PagingController(firstPageKey: 0);
      contentLimitLibrary = 6;
      offsetLibrary = 0;
      modelLibrary = [];
      isFirstInit = true;
      urlProduct = _catalogId;

      categoryTitle = _categoryTitle;
      await debugLog("catalogId = _catalogId before: $catalogId");
      //catalogTitle = _catalogTitle;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
      await debugLog("catalogId = _catalogId after: $catalogId");
    } catch (e) {
      print("resetProductListByCategory Product List Error: $e");
      if (e.toString() == "401" || e.toString().contains("Force logout")) {
        emit(UserForceLogout());
      } else {
        emit(GetListDataFailed(error: e.toString()));
      }
    }
  }

  Future<void> sortCatalogByDate(
    BuildContext context,
    bool? isAscendingSort,
    Map<String, dynamic>? sortLabelValue,
  ) async {
    libraryController = PagingController(firstPageKey: 0);
    contentLimitLibrary = 6;
    offsetLibrary = 0;
    modelLibrary = [];
    isFirstInit = true;
    isAscending = isAscendingSort;
    sortLabel = sortLabelValue;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
  }

  Future<void> updateFirebaseMessagingKey() async {
    try{
      await UserService().putNotificationKey();
    }catch(e){
      debugPrint("updateFirebaseMessagingKey: ${e.toString()}");
    }
  }
}

List<Map<String, dynamic>> listOfSorting(BuildContext context) {
  return [
    {
      "value": null,
      "sortLabel": "Default",
      "sortDetail": "Default",
    },
    {
      "value": false,
      "sortLabel": AppLocalizations.of(context)!.latest,
      "sortDetail": AppLocalizations.of(context)!.sortByNewer,
    },
    {
      "value": true,
      "sortLabel": AppLocalizations.of(context)!.earliest,
      "sortDetail": AppLocalizations.of(context)!.sortByOlder,
    }
  ];
}
