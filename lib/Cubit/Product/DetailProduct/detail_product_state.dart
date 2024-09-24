part of 'detail_product_cubit.dart';

abstract class DetailProductState extends Equatable {
  const DetailProductState();
  @override
  List<Object> get props => [];
}

class DetailProductInitial extends DetailProductState {}

class DetailProductLoading extends DetailProductState {}

class UserForceLogout extends DetailProductState {}

class GetDetailProductResponse extends DetailProductState {
  final ItemInfoModel detailProduct;
  const GetDetailProductResponse({required this.detailProduct});
  @override
  List<Object> get props => [detailProduct];
}

class GetFailedDetailProductReponse extends DetailProductState {
  final String message;
  const GetFailedDetailProductReponse({required this.message});
  @override
  List<Object> get props => [message];
}
