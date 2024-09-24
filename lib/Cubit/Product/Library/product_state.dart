part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class UserForceLogout extends ProductState {}

class GetListDataProduct extends ProductState {
  PagingController<int, LibraryProductModel> libraryController;
  int initContentCountLibrary;
  int contentCountLibrary;
  List<LibraryProductModel> modelLibrary;
  Map<String, dynamic>? sortLabel;

  bool isFirstInit;

  GetListDataProduct({
    required this.modelLibrary,
    required this.libraryController,
    required this.initContentCountLibrary,
    required this.contentCountLibrary,
    required this.isFirstInit,
    this.sortLabel,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        modelLibrary,
        libraryController,
        initContentCountLibrary,
        contentCountLibrary,
        isFirstInit,
        sortLabel!,
      ];
}

class GetListDataSearchProduct extends ProductState {}

class GetDetailDataProduct extends ProductState {
  DetailProductModel model;
  GetDetailDataProduct({required this.model});
  @override
  // TODO: implement props
  List<Object> get props => [model];
}

class GetListDataFailed extends ProductState {
  String error;
  GetListDataFailed({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class SortingLoading extends ProductState {}

class SortingSuccess extends ProductState {
  String sortLabel;
  SortingSuccess({required this.sortLabel});
  @override
  // TODO: implement props
  List<Object> get props => [sortLabel];
}

class SortingSuccessFailed extends ProductState {}
