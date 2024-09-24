import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_state.dart';
import 'package:revamp_eperpus_mobile/Service/book_rating_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/snacks.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_list_model.dart';

class ReviewListCubit extends Cubit<ReviewListState> {
  ReviewListCubit() : super(ReviewListInitial());

  ReviewListRes? reviewListRes;
  List<Review> reviewList = [];
  bool isLoading = true;

  Future<void> getBookReviewList(
    BuildContext context, {
    required int bookId,
  }) async {
    ReviewListResState(
      isLoading: isLoading,
    );
    try {
      reviewListRes = await BookRatingService.instance.getBookReviewList(
        bookId: bookId,
      );
      if(reviewListRes != null){
        reviewList = reviewListRes!.reviewList!;
        isLoading = false;
        emit(
          ReviewListResState(
            reviewListRes: reviewListRes,
            reviewList: reviewList,
            isLoading: isLoading,
          ),
        );
      }else{
        emit(ReviewListFailed());
      }
    } catch (err) {
      debugPrint(err.toString());
      emit(ReviewListFailed());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Snacks.errorAction(
            err.toString(),
            'Dismiss',
            () => ScaffoldMessenger.of(context).hideCurrentSnackBar,
            false,
          ),
        ),
      );
    }
  }
}
