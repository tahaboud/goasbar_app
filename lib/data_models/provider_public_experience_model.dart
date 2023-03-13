import 'package:goasbar/data_models/provider_public_experience_response.dart';

class ProviderPublicExperienceModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<ProviderPublicExperienceResults>? results;

  ProviderPublicExperienceModel({this.count, this.next, this.previous, this.results});

  ProviderPublicExperienceModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ProviderPublicExperienceResults>[];
      json['results'].forEach((v) {
        results!.add(ProviderPublicExperienceResults.fromJson(v));
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