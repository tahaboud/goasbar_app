class AffiliateSet {
  int? id;
  int? booking;
  String? firstName;
  String? lastName;
  String? gender;
  int? age;
  String? phoneNumber;
  String? status;
  dynamic cancelationComment;
  String? creationDate;

  AffiliateSet(
      {this.id,
        this.booking,
        this.firstName,
        this.lastName,
        this.gender,
        this.age,
        this.phoneNumber,
        this.status,
        this.cancelationComment,
        this.creationDate});

  AffiliateSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    booking = json['booking'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    age = json['age'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    cancelationComment = json['cancelation_comment'];
    creationDate = json['creation_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking'] = booking;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['age'] = age;
    data['phone_number'] = phoneNumber;
    data['status'] = status;
    data['cancelation_comment'] = cancelationComment;
    data['creation_date'] = creationDate;
    return data;
  }
}