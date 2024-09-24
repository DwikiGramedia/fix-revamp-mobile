part of 'device_collection_cubit.dart';

abstract class DeviceCollectionState extends Equatable {
  const DeviceCollectionState();
  @override
  List<Object> get props => [];
}

class DeviceCollectionInitial extends DeviceCollectionState {}

class DeviceCollectionLoading extends DeviceCollectionState {}

class GetDataCollectionEmpty extends DeviceCollectionState {
  String message;
  GetDataCollectionEmpty({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class UserForceLogout extends DeviceCollectionState {}

class DeviceReturnSuccess extends DeviceCollectionState {}

class GetBorrowedUnauthorized extends DeviceCollectionState {}

class GetDataCollectionResponse extends DeviceCollectionState {
  List<BorrowedBookModel> model;
  GetDataCollectionResponse({required this.model});
  @override
  // TODO: implement props
  List<Object> get props => [model];
}

class GetFailedDataCollection extends DeviceCollectionState {
  String message;
  GetFailedDataCollection({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
