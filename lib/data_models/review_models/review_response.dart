import 'package:goasbar/data_models/review_models/user_for_review.dart';

class ReviewResponse {
  int? id;
  int? booking;
  UserForReview? user;
  String? rate;
  String? comment;
  String? creationDate;

  ReviewResponse({this.id, this.user, this.rate, this.comment, this.creationDate});

  ReviewResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    booking = json['booking'];
    user = json['user'] != null ? UserForReview.fromJson(json['user']) : null;
    rate = json['rate'];
    comment = json['comment'];
    creationDate = json['creation_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking'] = booking;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['rate'] = rate;
    data['comment'] = comment;
    data['creation_date'] = creationDate;
    return data;
  }
}