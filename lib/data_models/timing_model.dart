import 'package:goasbar/data_models/timing_response.dart';

class TimingModel {
  TimingResponse? response;

  TimingModel({this.response});

  TimingModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? TimingResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}