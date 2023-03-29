class UserForReview {
  int? id;
  String? firstName;
  String? lastName;
  String? image;

  UserForReview({this.id, this.firstName, this.lastName, this.image});

  UserForReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image'] = image;
    return data;
  }
}