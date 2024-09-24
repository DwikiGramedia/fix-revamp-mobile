import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/model/Product/Category/GetCatalogInformationModel.dart';

import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();
  @override
  List<Object?> get props => [];
}

class CategoryListInitial extends CategoryListState {}

class CategorylistLoading extends CategoryListState {}

class GetCategorylistSuccess extends CategoryListState {
  GetCatalogInformationModel model;
  GetCategorylistSuccess({required this.model});

  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class GetCategoryBooklistSuccess extends CategoryListState {
  PagingController<int, LibraryProductModel> categoryController;
  int initContentCountCategory;
  int contentCountCategory;
  List<LibraryProductModel> modelCategory;

  bool isFirstInit;

  GetCategoryBooklistSuccess(
      {required this.categoryController,
      required this.contentCountCategory,
      required this.initContentCountCategory,
      required this.isFirstInit,
      required this.modelCategory});
  @override
  // TODO: implement props
  List<Object> get props => [
        modelCategory,
        categoryController,
        initContentCountCategory,
        contentCountCategory,
        isFirstInit,
      ];
}

class GetCategorylistFailed extends CategoryListState {
  String message;
  GetCategorylistFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
