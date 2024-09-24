import 'package:equatable/equatable.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_list_model.dart';

abstract class ReviewListState extends Equatable {
  const ReviewListState();
  @override
  List<Object?> get props => [];
}

class ReviewListInitial extends ReviewListState {}

class ReviewListLoading extends ReviewListState {}

class ReviewListResState extends ReviewListState {
  final ReviewListRes? reviewListRes;
  final List<Review>? reviewList;
  final bool? isLoading;
  final bool? isEmpty;

  const ReviewListResState({
    this.reviewListRes,
    this.reviewList,
    this.isLoading,
    this.isEmpty,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [reviewListRes, reviewList, isLoading];
}

class ReviewListFailed extends ReviewListState {}

