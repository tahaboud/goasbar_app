import 'package:goasbar/data_models/user_image_response.dart';

class UserImageModel {
  UserImageResponse? response;

  UserImageModel({this.response});

  UserImageModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? UserImageResponse.fromJson(json['response'])
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