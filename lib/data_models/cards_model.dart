class CardsModel {
  List<Response>? response;

  CardsModel({this.response});

  CardsModel.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? registrationId;
  String? brand;
  String? binNumber;
  String? lastDigits;
  int? expiryMonth;
  int? expiryYear;

  Response(
      {this.registrationId,
        this.brand,
        this.binNumber,
        this.lastDigits,
        this.expiryMonth,
        this.expiryYear});

  Response.fromJson(Map<String, dynamic> json) {
    registrationId = json['registrationId'];
    brand = json['brand'];
    binNumber = json['binNumber'];
    lastDigits = json['lastDigits'];
    expiryMonth = json['expiryMonth'];
    expiryYear = json['expiryYear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['registrationId'] = registrationId;
    data['brand'] = brand;
    data['binNumber'] = binNumber;
    data['lastDigits'] = lastDigits;
    data['expiryMonth'] = expiryMonth;
    data['expiryYear'] = expiryYear;
    return data;
  }
}
