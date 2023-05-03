class Errors {
  String? code;
  String? detail;
  String? attr;

  Errors({this.code, this.detail, this.attr});

  Errors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    detail = json['detail'];
    attr = json['attr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['detail'] = detail;
    data['attr'] = attr;
    return data;
  }
}