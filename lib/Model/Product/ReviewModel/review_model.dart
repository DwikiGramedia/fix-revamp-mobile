import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class Review {
  final String? email;
  final dynamic badge;
  final int? id;
  final String? item;
  final String? reviewDate;
  final int? rating;
  final String? reviewText;
  final String? firstName;
  final String? lastName;

  Review({
    this.email,
    this.badge,
    this.id,
    this.item,
    this.reviewDate,
    this.rating,
    this.reviewText,
    this.firstName,
    this.lastName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      email: getJsonValueAsString(json, 'email'),
      badge: getJsonValueAsString(json, 'badge'),
      id: getJsonValueAsInt(json, 'id'),
      item: getJsonValueAsString(json, 'item'),
      reviewDate: getJsonValueAsString(json, 'review_date'),
      rating: getJsonValueAsInt(json, 'rating'),
      reviewText: getJsonValueAsString(json, 'review'),
      firstName: getJsonValueAsString(json, 'first_name'),
      lastName: getJsonValueAsString(json, 'last_name'),
    );
  }
}
