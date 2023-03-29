import 'package:goasbar/data_models/affiliate_set_model.dart';
import 'package:goasbar/data_models/experience_booking_timing_model.dart';
import 'package:goasbar/data_models/review_model_booking_history.dart';

class BookingsListResults {
  int? id;
  ExperienceBookingTiming? experienceTiming;
  String? status;
  String? creationDate;
  dynamic cancelationComment;
  String? price;
  List<AffiliateSet>? affiliateSet;
  ReviewModelBookingHistory? review;

  BookingsListResults(
      {this.id,
        this.experienceTiming,
        this.status,
        this.creationDate,
        this.cancelationComment,
        this.price,
        this.review,
        this.affiliateSet});

  BookingsListResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experienceTiming = json['experience_timing'] != null
        ? ExperienceBookingTiming.fromJson(json['experience_timing'])
        : null;
    status = json['status'];
    creationDate = json['creation_date'];
    cancelationComment = json['cancelation_comment'];
    price = json['price'];
    review = json['review'] != null ? ReviewModelBookingHistory.fromJson(json['review']) : null;
    if (json['affiliate_set'] != null) {
      affiliateSet = <AffiliateSet>[];
      json['affiliate_set'].forEach((v) {
        affiliateSet!.add(AffiliateSet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (experienceTiming != null) {
      data['experience_timing'] = experienceTiming!.toJson();
    }
    data['status'] = status;
    data['creation_date'] = creationDate;
    data['cancelation_comment'] = cancelationComment;
    data['price'] = price;
    if (review != null) {
      data['review'] = review!.toJson();
    }
    if (affiliateSet != null) {
      data['affiliate_set'] =
          affiliateSet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}