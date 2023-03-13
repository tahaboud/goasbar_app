class UserForProviderTimingBooking {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? gender;
  int? age;

  UserForProviderTimingBooking(
      {this.id,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.gender,
        this.age});

  UserForProviderTimingBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['age'] = age;
    return data;
  }
}