import 'package:goasbar/data_models/experience_response.dart';

class ExperienceModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<ExperienceResults>? results;

  ExperienceModel({this.count, this.next, this.previous, this.results});

  ExperienceModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ExperienceResults>[];
      json['results'].forEach((v) {
        results!.add(ExperienceResults.fromJson(v));
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