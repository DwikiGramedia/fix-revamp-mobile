part of 'search_book_cubit.dart';

@immutable
abstract class SearchBookState {
  const SearchBookState();
  @override
  List<Object> get props => [];
}

class SearchBookInitial extends SearchBookState {}

class SearchBookLoading extends SearchBookState {}

class SearchBookEmpty extends SearchBookState {}

class SearchBookFocus extends SearchBookState {
  List<String> historyList;
  SearchBookFocus({required this.historyList});

  @override
  // TODO: implement props
  List<Object> get props => [historyList];
}

class GetSearchBookList extends SearchBookState {
  List<LibraryProductModel> model;
  GetSearchBookList({required this.model});

  @override
  // TODO: implement props
  List<Object> get props => [model];
}

class SearchBookFailed extends SearchBookState {
  String error;
  SearchBookFailed({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class GetSearchBookDetailProduct extends SearchBookState {
  DetailProductModel model;
  GetSearchBookDetailProduct({required this.model});
  @override
  // TODO: implement props
  List<Object> get props => [model];
}

class OnTextChange extends SearchBookState {}

class GetSearchBookDetailFailed extends SearchBookState {
  String error;
  GetSearchBookDetailFailed({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class GetSearchBookResponse extends SearchBookState {
  final List<ProductData> model;
  const GetSearchBookResponse({required this.model});
  @override
  List<Object> get props => [model];
}

class GetSearchBookResponseSuccess extends SearchBookState{
  PagingController<int, LibraryProductModel> libraryController;
  int initContentCountLibrary;
  int contentCountLibrary;
  List<LibraryProductModel> modelLibrary;

  bool isFirstInit;

  GetSearchBookResponseSuccess({
    required this.modelLibrary,
    required this.libraryController,
    required this.initContentCountLibrary,
    required this.contentCountLibrary,
    required this.isFirstInit,
  });
  @override
  // TODO: implement props
  List<Object> get props => [
    modelLibrary,
    libraryController,
    initContentCountLibrary,
    contentCountLibrary,
    isFirstInit,
  ];
}

class GetFailedSearchBookResponse extends SearchBookState {
  final String message;
  const GetFailedSearchBookResponse({required this.message});
  @override
  List<Object> get props => [message];
}
