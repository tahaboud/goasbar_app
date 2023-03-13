import 'package:goasbar/data_models/review_response.dart';

class ReviewModel {
  ReviewResponse? response;

  ReviewModel({this.response});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? ReviewResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}