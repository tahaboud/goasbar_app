class UserForProviderTimingBooking {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? gender;
  String? image;
  int? age;
  String? city;
  String? email;

  UserForProviderTimingBooking(
      {this.id,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.gender,
        this.image,
        this.age,
        this.city,
        this.email});

  UserForProviderTimingBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    image = json['image'];
    age = json['age'];
    city = json['city'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['image'] = image;
    data['age'] = age;
    data['city'] = city;
    data['email'] = email;
    return data;
  }
}