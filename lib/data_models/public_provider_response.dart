class PublicResponse {
  int? id;
  String? nickname;
  String? email;
  dynamic website;
  String? about;
  String? phoneNumber;
  dynamic twitterAccount;
  dynamic facebookAccount;
  dynamic instagramAccount;

  PublicResponse(
      {this.id,
        this.nickname,
        this.email,
        this.website,
        this.about,
        this.phoneNumber,
        this.twitterAccount,
        this.facebookAccount,
        this.instagramAccount});

  PublicResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    email = json['email'];
    website = json['website'];
    about = json['about'];
    phoneNumber = json['phone_number'];
    twitterAccount = json['twitter_account'];
    facebookAccount = json['facebook_account'];
    instagramAccount = json['instagram_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nickname'] = nickname;
    data['email'] = email;
    data['website'] = website;
    data['about'] = about;
    data['phone_number'] = phoneNumber;
    data['twitter_account'] = twitterAccount;
    data['facebook_account'] = facebookAccount;
    data['instagram_account'] = instagramAccount;
    return data;
  }
}