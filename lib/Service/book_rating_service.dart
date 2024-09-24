import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_constant.dart';
import 'package:revamp_eperpus_mobile/Helpers/snacks.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_list_model.dart';
import 'package:revamp_eperpus_mobile/model/rating_book_add_res.dart';

class BookRatingService {
  static final BookRatingService _instance = BookRatingService._internal();
  factory BookRatingService() => _instance;
  BookRatingService._internal();
  static BookRatingService get instance => _instance;

  Future<RatingBookAddRes> postBookRatingAdd(
    BuildContext context, {
    required int borrowingId,
    int rating = 0,
    String reviewText = '',
  }) async {
    try {
      final data = {
        "borrowing_id": borrowingId,
        "rating": rating,
        "review": reviewText,
      };
      String endpoint = ApiClient.instance.baseUrl + ApiConstant.booksReview;
      final response = await ApiClient.instance.postData(endpoint, data);
      final RatingBookAddRes ratingBookAddRes =
          RatingBookAddRes.fromJson(response.data);
      if (ratingBookAddRes.isSuccess()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(ratingBookAddRes.message),
          ),
        );
      }
      if (ratingBookAddRes.isError() || ratingBookAddRes.isConflict()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: Text(ratingBookAddRes.message),
          ),
        );
      }
      return ratingBookAddRes;
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(err.toString()),
        ),
      );
      return RatingBookAddRes(statusCode: 400, message: err.toString());
    }
  }

  Future<ReviewListRes?> getBookReviewList({required int bookId}) async {
    try {
      String endpoint =
          ApiClient.instance.baseUrl + ApiConstant.booksReviewList(bookId);
      final response = await ApiClient.instance.getData(
        endpoint,
        '',
      );
      if (response.statusCode == 200) {
        return ReviewListRes.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Exeption Get: $e");
      return null;
    }
  }
}
