import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_state.dart';
import 'package:revamp_eperpus_mobile/Helpers/alert_unauthorized.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Dialog/unauthorized_dialog.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/model/CatalogesDataModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit() : super(CatalogInitial());

  PagingController<int, LibraryProductModel> categoryController =
      PagingController(firstPageKey: 0);
  int contentLimitCategory = 6;
  int offsetCategory = 0;
  List<LibraryProductModel> modelCategory = [];
  bool isFirstInit = true;
  List<CatalogData> catalog = [];
  List<String> searchingHistoryList = [];

  void initState() {
    emit(GetCatalogListSuccess(
        categoryController: categoryController,
        contentCountCategory: offsetCategory,
        initContentCountCategory: contentLimitCategory,
        isFirstInit: isFirstInit,
        modelCategory: modelCategory));
  }

  void resetCategory() {
    categoryController = PagingController(firstPageKey: 0);
    contentLimitCategory = 6;
    offsetCategory = 0;
    modelCategory = [];
    isFirstInit = true;
  }

  void getCatalog(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      emit(CatalogLoading());

      CatalogesDataModel organization = await ProductService().getCatalogs();
      if (organization.catalogs.length <= 1) {
        sharedPreferences.setInt(
            "catalogId", organization.catalogs.first.id ?? 0);
      }

      if (organization.catalogs.isEmpty) {
        emit(GetCatalogFailed(message: "Error, please wait a moment"));
      } else {
        catalog = organization.catalogs;
        emit(GetCatalogSuccess(catalogList: organization.catalogs));
      }
    } catch (e) {
      debugPrint("getCatalog error throw ${e.toString()}");
      if (e.toString().contains("Force logout")) {
        emit(CatalogUserForceLogout());
      } else if (e == "401" || e == 401) {
        emit(CatalogUserUnauthorized());
      } else {
        debugPrint("getCatalog error ${e.toString()}");
      }
    }
  }

  Future<void> getProductCategoryList({
    required BuildContext context,
    required String href,
    required String query,
    int? pageKey,
    String? organizationId,
    String? catalogId,
  }) async {
    try {
      if (isFirstInit) {
        emit(CatalogLoading());
      }
      modelCategory = await ProductService().getProductsByCatalog(
        href: href,
        queryString: query,
        offset: offsetCategory,
        limit: contentLimitCategory,
      );
      if (modelCategory.length < contentLimitCategory) {
        categoryController.appendLastPage(modelCategory);
      } else {
        offsetCategory = offsetCategory + contentLimitCategory;
        final nextPageKey = contentLimitCategory + modelCategory.length;
        categoryController.appendPage(modelCategory, nextPageKey);
      }
      isFirstInit = false;
      emit(
        GetCatalogListSuccess(
          categoryController: categoryController,
          contentCountCategory: offsetCategory,
          initContentCountCategory: contentLimitCategory,
          isFirstInit: isFirstInit,
          modelCategory: modelCategory,
        ),
      );
    } catch (e) {
      debugPrint('error: $e');
      emit(GetCatalogFailed(message: e.toString()));
      debugPrint("getCatalog error throw ${e.toString()}");
      if (e.toString().contains("Force logout")) {
        showUnauthorizedDialog(
          context,
          AppLocalizations.of(context)!,
        );
        emit(GetCatalogForceLogout());
      } else if (e == "401" || e == 401) {
        emit(GetCatalogUnauthorized());
      } else {
        debugPrint("getCatalog error ${e.toString()}");
      }
    }
  }

  Future<void> setSearchedHistory(String searchHistory) async {
    if (searchingHistoryList.contains(searchHistory)) {
      searchingHistoryList.removeWhere((element) => element == searchHistory);
    }
    if (searchingHistoryList.length == 10) {
      searchingHistoryList.removeAt(0);
    }
    searchingHistoryList.add(searchHistory);
    await setSearchHistory(searchingHistoryList);
  }

  Future<void> getHistoryList({String? item}) async {
    try {
      searchingHistoryList = await getSearchHistory();
      emit(CatalogBookFocus(historyList: searchingHistoryList));
    } catch (e) {
      emit(GetCatalogFailed(message: e.toString()));
      emit(CatalogBookFocus(historyList: searchingHistoryList));
    }
  }
}
