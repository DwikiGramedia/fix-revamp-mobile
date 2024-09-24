part of 'collection_cubit.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();
  @override
  List<Object> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class GetListDataProductCollection extends CollectionState {
  final PagingController<int, LibraryProductModel> collectionController;
  final int initContentCountCollection;
  final int contentCountCollection;
  final List<LibraryProductModel> modelCollection;
  final bool isFirstInit;

  const GetListDataProductCollection({
    required this.modelCollection,
    required this.collectionController,
    required this.initContentCountCollection,
    required this.contentCountCollection,
    required this.isFirstInit,
  });
  @override
  List<Object> get props => [
        modelCollection,
        collectionController,
        initContentCountCollection,
        contentCountCollection,
        isFirstInit,
      ];
}

class GetListCollectionFailed extends CollectionState {
  final String error;
  const GetListCollectionFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class CollectionUserForceLogout extends CollectionState {}

class GetDetailDataCollection extends CollectionState {
  final DetailProductModel model;
  const GetDetailDataCollection({required this.model});
  @override
  List<Object> get props => [model];
}
