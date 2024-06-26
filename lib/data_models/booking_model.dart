import 'package:goasbar/data_models/booking_response.dart';

class BookingModel {
  BookingResponse? response;
  String? paymentUrl;
  String? tokensd;

  BookingModel({this.response});

  BookingModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? BookingResponse.fromJson(json['response'])
        : null;
    paymentUrl = json["payment_url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}
