import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class RatingModel {
  double average;
  int total;

  RatingModel({required this.average, required this.total});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: getJsonValueAsDouble(json, 'average'),
      total: getJsonValueAsInt(json, 'total'),
    );
  }
  Map<String,dynamic> toJson(){
    return {
      "average":average,
      "total":total
    };
  }
}
