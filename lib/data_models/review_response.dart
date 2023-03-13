class ReviewResponse {
  int? id;
  int? booking;
  String? rate;
  dynamic comment;
  String? creationDate;

  ReviewResponse({this.id, this.booking, this.rate, this.comment, this.creationDate});

  ReviewResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    booking = json['booking'];
    rate = json['rate'];
    comment = json['comment'];
    creationDate = json['creation_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking'] = booking;
    data['rate'] = rate;
    data['comment'] = comment;
    data['creation_date'] = creationDate;
    return data;
  }
}