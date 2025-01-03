class ChatUser {
  int id;
  String firstName;
  String lastName;
  String? nickname;
  String image;

  ChatUser(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.nickname,
      required this.image});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      nickname: json["nickname"],
      image: json["image"],
    );
  }
}
