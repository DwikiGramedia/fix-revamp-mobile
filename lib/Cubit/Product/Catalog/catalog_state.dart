import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/model/CatalogesDataModel.dart';

import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();
  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class GetCatalogSuccess extends CatalogState {
  final List<CatalogData>? catalogList;
  const GetCatalogSuccess({required this.catalogList});

  @override
  // TODO: implement props
  List<Object?> get props => [catalogList];
}

class CatalogUserForceLogout extends CatalogState {}

class CatalogUserUnauthorized extends CatalogState {}

class GetCatalogListSuccess extends CatalogState {
  final PagingController<int, LibraryProductModel> categoryController;
  final int initContentCountCategory;
  final int contentCountCategory;
  final List<LibraryProductModel> modelCategory;

  final bool isFirstInit;

  const GetCatalogListSuccess({
    required this.categoryController,
    required this.contentCountCategory,
    required this.initContentCountCategory,
    required this.isFirstInit,
    required this.modelCategory,
  });
  @override
  List<Object> get props => [
        modelCategory,
        categoryController,
        initContentCountCategory,
        contentCountCategory,
        isFirstInit,
      ];
}

class CatalogBookFocus extends CatalogState {
  final List<String>? historyList;
  const CatalogBookFocus({required this.historyList});

  @override
  // TODO: implement props
  List<Object?> get props => [historyList];
}

class GetCatalogFailed extends CatalogState {
  final String message;
  const GetCatalogFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class GetCatalogForceLogout extends CatalogState {}

class GetCatalogUnauthorized extends CatalogState {}
