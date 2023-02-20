import 'package:goasbar/data_models/timing_response.dart';

class TimingListModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<TimingResponse>? results;

  TimingListModel({this.count, this.next, this.previous, this.results});

  TimingListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <TimingResponse>[];
      json['results'].forEach((v) {
        results!.add(TimingResponse.fromJson(v));
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