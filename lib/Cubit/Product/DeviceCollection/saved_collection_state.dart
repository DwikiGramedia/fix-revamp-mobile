part of 'saved_collection_cubit.dart';

abstract class SavedCollectionState extends Equatable {
  const SavedCollectionState();
  @override
  List<Object> get props => [];
}

class SavedCollectionInitial extends SavedCollectionState {}
class SavedCollectionLoading extends SavedCollectionState {}

class GetDataSavedCollection extends  SavedCollectionState{
  List<SavedBook> model;
  GetDataSavedCollection({required this.model});
  @override
  // TODO: implement props
  List<Object> get props => [model];
}

class GetEmptyDataSavedCollection extends  SavedCollectionState{
  String message;
  GetEmptyDataSavedCollection({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message];
}


class GetFailedSaveDataCollection extends SavedCollectionState {
  String message;
  List<SavedBook> model;
  GetFailedSaveDataCollection({required this.message, required this.model});
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
