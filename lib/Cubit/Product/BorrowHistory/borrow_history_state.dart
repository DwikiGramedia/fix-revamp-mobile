part of 'borrow_hirstory_cubit.dart';

abstract class BorrowHistoryState extends Equatable {
  const BorrowHistoryState();
  @override
  List<Object> get props => [];
}

class BorrowHistoryInitial extends BorrowHistoryState {}

class BorrowHistoryLoading extends BorrowHistoryState {}

class UserForceLogout extends BorrowHistoryState {}

class GetListOfBorrowingHistories extends BorrowHistoryState {
  PagingController<int, HistoryBorrowProductModel> borrowingHistoryController;
  int initContentCountHistories;
  int contentCountHistories;
  List<HistoryBorrowProductModel> modelHistories;
  bool isFirstInit;

  GetListOfBorrowingHistories({
    required this.modelHistories,
    required this.borrowingHistoryController,
    required this.initContentCountHistories,
    required this.contentCountHistories,
    required this.isFirstInit,
  });

  @override
  List<Object> get props => [
    modelHistories,
    borrowingHistoryController,
    initContentCountHistories,
    contentCountHistories,
    isFirstInit,
  ];
}

class GetListOfSearchHistories extends BorrowHistoryState {
  final List<HistoryBorrowProductModel> searchHistories;

  const GetListOfSearchHistories({
    required this.searchHistories,
  });

  @override
  List<Object> get props => [
    searchHistories,
  ];
}

class GetFailedBorrowHistoryResponse extends BorrowHistoryState {
  final String message;
  const GetFailedBorrowHistoryResponse({required this.message});
  @override
  List<Object> get props => [message];
}
