import 'package:goasbar/data_models/review_models/review_response.dart';

class ReviewsModelList {
  int? count;
  dynamic next;
  dynamic previous;
  List<ReviewResponse>? results;

  ReviewsModelList({this.count, this.next, this.previous, this.results});

  ReviewsModelList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ReviewResponse>[];
      json['results'].forEach((v) {
        results!.add(ReviewResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}