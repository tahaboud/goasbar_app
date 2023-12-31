class PublicProviderResponse {
  int? id;
  String? nickname;
  String? email;
  dynamic website;
  String? about;
  String? image;
  String? phoneNumber;
  dynamic twitterAccount;
  dynamic facebookAccount;
  dynamic instagramAccount;

  PublicProviderResponse(
      {this.id,
        this.nickname,
        this.email,
        this.website,
        this.about,
        this.image,
        this.phoneNumber,
        this.twitterAccount,
        this.facebookAccount,
        this.instagramAccount});

  PublicProviderResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    email = json['email'];
    website = json['website'];
    about = json['about'];
    image = json['image'];
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
    data['image'] = image;
    data['phone_number'] = phoneNumber;
    data['twitter_account'] = twitterAccount;
    data['facebook_account'] = facebookAccount;
    data['instagram_account'] = instagramAccount;
    return data;
  }
}