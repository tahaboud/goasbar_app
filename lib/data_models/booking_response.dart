import 'package:goasbar/data_models/affiliate_set_model.dart';

class BookingResponse {
  int? id;
  int? experienceTiming;
  String? status;
  String? creationDate;
  dynamic cancelationComment;
  String? price;
  List<AffiliateSet>? affiliateSet;

  BookingResponse(
      {this.id,
        this.experienceTiming,
        this.status,
        this.creationDate,
        this.cancelationComment,
        this.price,
        this.affiliateSet});

  BookingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experienceTiming = json['experience_timing'];
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