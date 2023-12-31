import 'package:goasbar/data_models/public_provider_response.dart';

class PublicProviderModel {
  PublicProviderResponse? response;

  PublicProviderModel({this.response});

  PublicProviderModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? PublicProviderResponse.fromJson(json['response'])
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