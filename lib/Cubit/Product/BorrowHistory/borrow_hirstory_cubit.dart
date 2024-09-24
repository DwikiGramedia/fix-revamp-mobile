import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:revamp_eperpus_mobile/model/Product/product_model.dart';

part 'borrow_history_state.dart';

class BorrowHistoryCubit extends Cubit<BorrowHistoryState> {
  BorrowHistoryCubit() : super(BorrowHistoryInitial());

  PagingController<int, HistoryBorrowProductModel> borrowingHistoryController =
      PagingController(firstPageKey: 0);
  int contentLimit = 6;
  int offset = 0;
  List<HistoryBorrowProductModel> borrowingHistories = [];
  bool isFirstInit = true;

  void initState() {
    emit(BorrowHistoryLoading());
    emit(GetListOfBorrowingHistories(
      modelHistories: borrowingHistories,
      borrowingHistoryController: borrowingHistoryController,
      initContentCountHistories: contentLimit,
      contentCountHistories: offset,
      isFirstInit: isFirstInit,
    ));
  }

  void resetPagination() {
    borrowingHistoryController = PagingController(firstPageKey: 0);
    contentLimit = 12;
    offset = 0;
    borrowingHistories = [];
    isFirstInit = true;
  }


  void getHistoryCollection(DateTime dateTime) async {
    borrowingHistories = await UserService().getBorrowBookCurrentUser(
      dateTime,
      offset,
      contentLimit,
    );
    if (borrowingHistories.length < contentLimit) {
      borrowingHistoryController.appendLastPage(borrowingHistories);
    } else {
      offset = offset + contentLimit;
      final nextPageKey = contentLimit + borrowingHistories.length;
      borrowingHistoryController.appendPage(borrowingHistories, nextPageKey);
    }
    isFirstInit = false;
    emit(
      GetListOfBorrowingHistories(
        modelHistories: borrowingHistories,
        borrowingHistoryController: borrowingHistoryController,
        initContentCountHistories: contentLimit,
        contentCountHistories: offset,
        isFirstInit: isFirstInit,
      ),
    );
  }

  void getListHistory(DateTime dateTime) async {
    try {
      if (isFirstInit) {
        emit(BorrowHistoryLoading());
        getHistoryCollection(dateTime);
      } else {
        getHistoryCollection(dateTime);
      }
    } catch (e) {
      emit(GetFailedBorrowHistoryResponse(message: e.toString()));
    }
  }

  List<HistoryBorrowProductModel> searchHistories = [];
  void searchHistory(String search) async {
    try {
      emit(BorrowHistoryLoading());

      searchHistories = await UserService().searchBorrowingHistory(search);
      emit(GetListOfSearchHistories(
        searchHistories: searchHistories,
      ));
    } catch (e) {
      if (e.toString() == "Force logout") {
        emit(UserForceLogout());
      } else {
        emit(GetFailedBorrowHistoryResponse(message: e.toString()));
      }
    }
  }
}
