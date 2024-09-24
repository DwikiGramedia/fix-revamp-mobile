import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_state.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/model/Product/Category/GetCatalogInformationModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

import 'package:revamp_eperpus_mobile/Helpers/cache.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  CategoryListCubit() : super(CategoryListInitial());

  PagingController<int, LibraryProductModel> categoryController =
      PagingController(firstPageKey: 0);
  int contentLimitCategory = 6;
  int offsetCategory = 0;
  List<LibraryProductModel> modelCategory = [];
  bool isFirstInit = true;

  void initState() {
    emit(CategorylistLoading());
    emit(GetCategoryBooklistSuccess(
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

  void getCategoryList(String href) async {
    try {
      emit(CategorylistLoading());
      await debugLog(href);
      Future.delayed(Duration(seconds: 2), () async {
        GetCatalogInformationModel? model =
            await ProductService().getCategory(href, "");

        if (model != null) {
          emit(GetCategorylistSuccess(model: model));
        } else {
          emit(GetCategorylistFailed(message: "Error, please wait a moment"));
        }
      });
    } catch (e) {
      emit(GetCategorylistFailed(message: "Error, please wait a moment"));
    }
  }

  void getCategoryBooks(
      {int? organizationId, int? catalogId, required String category}) async {
    try {
      emit(CategorylistLoading());
      Future.delayed(Duration(seconds: 2), () async {
        List<LibraryProductModel>? model =
            await ProductService().getCategoryBooks(category: category);
        if (model != null) {
          emit(
            GetCategoryBooklistSuccess(
              categoryController: categoryController,
              contentCountCategory: offsetCategory,
              initContentCountCategory: contentLimitCategory,
              isFirstInit: isFirstInit,
              modelCategory: modelCategory,
            ),
          );
        } else {
          emit(GetCategorylistFailed(message: "Error, please wait a moment"));
        }
      });
    } catch (e) {}
  }

  void getCategoryCatalog(String href) {
    try {
      emit(CategorylistLoading());
      Future.delayed(Duration(seconds: 2), () async {
        GetCatalogInformationModel? model =
            await ProductService().getCategoryCatalog(href);
        if (model != null) {
          emit(GetCategorylistSuccess(model: model));
        } else {
          emit(GetCategorylistFailed(message: "Error, please wait a moment"));
        }
      });
    } catch (e) {
      emit(GetCategorylistFailed(message: "Error, please wait a moment"));
    }
  }

  Future<void> getProductCategoryList(
      {int? pageKey,
      String? organizationId,
      String? catalogId,
      required String category}) async {
    try {
      if (isFirstInit) {
        emit(CategorylistLoading());
      }
      modelCategory = await ProductService().getCategoryBooks(
        limit: contentLimitCategory,
        offset: offsetCategory,
        category: category,
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
        GetCategoryBooklistSuccess(
          categoryController: categoryController,
          contentCountCategory: offsetCategory,
          initContentCountCategory: contentLimitCategory,
          isFirstInit: isFirstInit,
          modelCategory: modelCategory,
        ),
      );
    } catch (e) {
      debugPrint('error: $e');
      emit(GetCategorylistFailed(message: e.toString()));
    }
  }

  Future<void> getCategoryBooksCatalog(
      {int? pageKey,
      String? organizationId,
      String? catalogId,
      required String category,
      required String href,
      required String query}) async {
    try {
      if (isFirstInit) {
        emit(CategorylistLoading());
      }
      modelCategory = await ProductService().getCategoryBooksCatalog(
          limit: contentLimitCategory,
          offset: offsetCategory,
          category: category,
          href: href,
          query: query);
      if (modelCategory.length < contentLimitCategory) {
        categoryController.appendLastPage(modelCategory);
      } else {
        offsetCategory = offsetCategory + contentLimitCategory;
        final nextPageKey = contentLimitCategory + modelCategory.length;
        categoryController.appendPage(modelCategory, nextPageKey);
      }
      isFirstInit = false;
      emit(
        GetCategoryBooklistSuccess(
          categoryController: categoryController,
          contentCountCategory: offsetCategory,
          initContentCountCategory: contentLimitCategory,
          isFirstInit: isFirstInit,
          modelCategory: modelCategory,
        ),
      );
    } catch (e) {
      debugPrint('error: $e');
      emit(GetCategorylistFailed(message: e.toString()));
    }
  }
}
