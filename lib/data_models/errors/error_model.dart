import 'package:goasbar/data_models/errors/errors.dart';

class ErrorModel {
  String? type;
  List<Errors>? errors;

  ErrorModel({this.type, this.errors});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}