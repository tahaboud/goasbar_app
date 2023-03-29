class ReviewModelBookingHistory {
  int? id;
  String? rate;
  String? comment;

  ReviewModelBookingHistory({this.id, this.rate, this.comment});

  ReviewModelBookingHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json['rate'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rate'] = rate;
    data['comment'] = comment;
    return data;
  }
}