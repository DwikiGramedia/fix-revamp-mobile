import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_model.dart';

class ReviewListRes {
  Map<String, dynamic>? metadata;
  List<Review>? reviewList;
  ReviewListRes({this.metadata, this.reviewList});

  factory ReviewListRes.fromJson(json) {
    return ReviewListRes(
      metadata: getJsonValueAsJson(json, 'metadata'),
      reviewList: getJsonListValue(json, 'reviews')
          .map<Review>((dynamic value) => Review.fromJson(value))
          .toList(),
    );
  }
}
