import 'package:goasbar/data_models/bookings_list_response.dart';

class BookingsListModel {
  int? count;
  String? next;
  dynamic previous;
  List<BookingsListResults>? results;

  BookingsListModel({this.count, this.next, this.previous, this.results});

  BookingsListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['response'] != null) {
      results = <BookingsListResults>[];
      json['response'].forEach((v) {
        results!.add(BookingsListResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['response'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}