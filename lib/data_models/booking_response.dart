import 'package:goasbar/data_models/affiliate_set_model.dart';
import 'package:goasbar/data_models/experience_booking_timing_model.dart';

class BookingResponse {
  int? id;
  String? status;
  String? creationDate;
  dynamic cancelationComment;
  String? price;
  List<AffiliateSet>? affiliateSet;
  ExperienceBookingTiming? experienceBookingTiming;

  BookingResponse(
      {this.id,
        this.experienceBookingTiming,
        this.status,
        this.creationDate,
        this.cancelationComment,
        this.price,
        this.affiliateSet});

  BookingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    creationDate = json['creation_date'];
    cancelationComment = json['cancelation_comment'];
    experienceBookingTiming = json['experience_timing'] != null
        ? ExperienceBookingTiming.fromJson(json['experience_timing'])
        : null;
    price = json['price'];
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
    data['status'] = status;
    data['creation_date'] = creationDate;
    if (experienceBookingTiming != null) {
      data['experience_timing'] = experienceBookingTiming!.toJson();
    }
    data['cancelation_comment'] = cancelationComment;
    data['price'] = price;
    if (affiliateSet != null) {
      data['affiliate_set'] =
          affiliateSet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}