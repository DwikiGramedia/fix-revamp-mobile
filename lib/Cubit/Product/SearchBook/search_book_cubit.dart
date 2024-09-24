import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:revamp_eperpus_mobile/model/product_data.dart';

part 'search_book_state.dart';

class SearchBookCubit extends Cubit<SearchBookState> {
  SearchBookCubit() : super(SearchBookInitial());

  PagingController<int, LibraryProductModel> libraryController =
  PagingController(firstPageKey: 0);
  int contentLimitLibrary = 6;
  int offsetLibrary = 0;
  List<LibraryProductModel> modelLibrary = [];

  bool isFirstInit = true;

  List<LibraryProductModel> model = [];

  List<String> searchingHistoryList = [
    "Travel",
    "Cooking",
    "Design",
    "Travel",
  ];

  void changeState({required SearchBookState state}) async {
    emit(state);
  }

  void initState() {
    emit(SearchBookLoading());
    emit(GetSearchBookResponseSuccess(
      modelLibrary: modelLibrary,
      libraryController: libraryController,
      initContentCountLibrary: contentLimitLibrary,
      contentCountLibrary: offsetLibrary,
      isFirstInit: isFirstInit,
    ));
  }

  Future<void> addHistoryList({String? item}) async {
    try {
      if (item!.isEmpty) {
        emit(SearchBookFocus(historyList: searchingHistoryList));
      } else {
        if (searchingHistoryList.length >= 5) {
          searchingHistoryList.removeAt(0);
        }
        searchingHistoryList.add(item);
        searchingHistoryList = searchingHistoryList.reversed.toList();
        emit(SearchBookFocus(historyList: searchingHistoryList));
      }
      await debugLog("searchingHistoryList length ${searchingHistoryList.length}");
      // for (var i in searchingHistoryList) (await debugLog("masuk cubit searching ${i}"));
    } catch (e) {
      await debugLog('error: $e');
      emit(SearchBookFailed(error: e.toString()));
      emit(SearchBookFocus(historyList: searchingHistoryList));
    }
  }

  Future<void> getProductList(
      {int? pageKey, required String queryString}) async {
    try {
      emit(SearchBookLoading());
      model = await ProductService().productList(
        queryString: queryString,
        // limit: 6,
        // offset: 0,
      );
      if (model.isEmpty) {
        emit(SearchBookEmpty());
      } else {
        emit(GetSearchBookList(model: model));
      }
      // if (model.length < contentLimit) {
      //   libraryController.appendLastPage(model);
      // } else {
      //   offset = offset + contentLimit;
      //   final nextPageKey = contentLimit + model.length;
      //   libraryController.appendPage(model, nextPageKey);
      // }
      // isFirstInit = false;
      // emit(
      //   GetListDataProduct(
      //     model: model,
      //     pagingController: libraryController,
      //     initContentCount: contentLimit,
      //     contentCount: offset,
      //     isFirstInit: isFirstInit,
      //   ),
      // );
    } catch (e) {
      await debugLog('error: $e');
      emit(SearchBookFailed(error: e.toString()));
    }
  }

// void getDetailProduct(LibraryProductModel productData) async {
//   try {
//     emit(ProductLoading());
//     DetailProductModel model = await ProductService().detail(productData);
//     emit(GetDetailDataProduct(model: model));
//   } catch (e) {
//     await debugLog('GetListDataFailed hahaha');
//     emit(GetListDataFailed(error: e.toString()));
//   }
// }
}
