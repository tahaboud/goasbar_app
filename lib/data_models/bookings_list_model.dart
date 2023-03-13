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
    if (json['results'] != null) {
      results = <BookingsListResults>[];
      json['results'].forEach((v) {
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
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}