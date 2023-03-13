import 'package:goasbar/data_models/affiliate_set_model.dart';
import 'package:goasbar/data_models/user_for_provider_timing_booking.dart';

class ProviderTimingBookingResults {
  int? id;
  int? experienceTiming;
  UserForProviderTimingBooking? user;
  String? status;
  String? creationDate;
  dynamic cancelationComment;
  String? price;
  List<dynamic>? affiliateSet;

  ProviderTimingBookingResults(
      {this.id,
        this.experienceTiming,
        this.user,
        this.status,
        this.creationDate,
        this.cancelationComment,
        this.price,
        this.affiliateSet});

  ProviderTimingBookingResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experienceTiming = json['experience_timing'];
    user = json['user'] != null ? UserForProviderTimingBooking.fromJson(json['user']) : null;
    status = json['status'];
    creationDate = json['creation_date'];
    cancelationComment = json['cancelation_comment'];
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
    data['experience_timing'] = experienceTiming;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['status'] = status;
    data['creation_date'] = creationDate;
    data['cancelation_comment'] = cancelationComment;
    data['price'] = price;
    if (affiliateSet != null) {
      data['affiliate_set'] =
          affiliateSet!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}