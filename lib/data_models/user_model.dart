class UserModel {
  int? id;
  String? userName;
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  List<int>? favoriteExperiences;
  String? gender;
  String? birthDate;
  String? image;
  String? city;
  bool? emailConfirmed;
  bool? isProvider;

  UserModel(
      {this.id,
        this.userName,
        this.email,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.favoriteExperiences,
        this.gender,
        this.birthDate,
        this.image,
        this.city,
        this.emailConfirmed,
        this.isProvider});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    favoriteExperiences = json['favorite_experiences'].cast<int>();
    gender = json['gender'];
    birthDate = json['birth_date'];
    image = json['image'];
    city = json['city'];
    emailConfirmed = json['email_confirmed'];
    isProvider = json['is_provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = userName;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['favorite_experiences'] = favoriteExperiences;
    data['gender'] = gender;
    data['birth_date'] = birthDate;
    data['image'] = image;
    data['city'] = city;
    data['email_confirmed'] = emailConfirmed;
    data['is_provider'] = isProvider;
    return data;
  }
}