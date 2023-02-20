import 'package:goasbar/data_models/provider_response.dart';

class ProviderModel {
  Response? response;

  ProviderModel({this.response});

  ProviderModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? Response.fromJson(json['response'])
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

