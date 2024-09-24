import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/book_rating_add_state.dart';
import 'package:revamp_eperpus_mobile/Service/book_rating_service.dart';
import 'package:revamp_eperpus_mobile/model/rating_book_add_res.dart';

class BookRatingAddCubit extends Cubit<BookRatingAddState> {
  BookRatingAddCubit() : super(BookRatingAddInitial());

  RatingBookAddRes? _response;

  String? errorText(String emptyText, String minimumText) {
    if (reviewText.isEmpty) {
      return emptyText;
    }
    if (reviewText.length < 20) {
      return minimumText;
    }
    // return null if the text is valid
    return null;
  }

  List<String> ratingTextList = [];
  void setRatingTextList(List<String> _ratingTextList) {
    ratingTextList = _ratingTextList;
  }

  int rating = 1;
  String ratingText = '';
  void setRating(int _rating) {
    rating = _rating + 1;
    ratingText = ratingTextList[rating - 1];
    emit(BookRatingAddRes(
      reviewText: reviewText,
      rating: rating,
      ratingText: ratingText,
    ));
  }

  String reviewText = '';
  void setReviewText(String text) {
    reviewText = text;
    emit(BookRatingAddRes(
      reviewText: reviewText,
      rating: rating,
      ratingText: ratingText,
    ));
  }

  Future<void> postBookRatingAdd(
    BuildContext context, {
    required int borrowingId,
    required String reviewText,
  }) async {
    try {
      final RatingBookAddRes response =
          await BookRatingService.instance.postBookRatingAdd(
        context,
        borrowingId: borrowingId,
        rating: rating,
        reviewText: reviewText,
      );
      emit(BookRatingSentState(
        responseCode: response.statusCode,
        responseMessage: response.message,
      ));
    } catch (err) {
      emit(BookRatingSentState(
        responseMessage: err.toString(),
        responseCode: 401,
      ));
    }
  }
}
