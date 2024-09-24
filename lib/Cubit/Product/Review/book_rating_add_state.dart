import 'package:equatable/equatable.dart';

abstract class BookRatingAddState extends Equatable {
  const BookRatingAddState();
  @override
  List<Object?> get props => [];
}

class BookRatingAddInitial extends BookRatingAddState {}

class BookRatingAddRes extends BookRatingAddState {
  final int? statusCode;
  final String? message;
  final String? reviewText;
  final int? rating;
  final String? ratingText;
  const BookRatingAddRes({
    this.statusCode,
    this.message,
    this.reviewText,
    this.rating,
    this.ratingText,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        statusCode,
        message,
        reviewText,
        rating,
        ratingText,
      ];
}

class BookRatingSentState extends BookRatingAddState {
  String responseMessage = "";
  int responseCode = 200;
  BookRatingSentState({
    required this.responseMessage,
    required this.responseCode,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [responseMessage, responseCode];
}
