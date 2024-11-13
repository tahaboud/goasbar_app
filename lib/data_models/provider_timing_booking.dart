import 'package:goasbar/data_models/provider_timing_booking_response.dart';

class ProviderTimingBooking {
  int? count;
  dynamic next;
  dynamic previous;
  List<ProviderTimingBookingResults>? results;

  ProviderTimingBooking({this.count, this.next, this.previous, this.results});

  ProviderTimingBooking.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['response'] != null) {
      results = <ProviderTimingBookingResults>[];
      json['response'].forEach((v) {
        results!.add(ProviderTimingBookingResults.fromJson(v));
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
