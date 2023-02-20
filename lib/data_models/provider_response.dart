class Response {
  int? id;
  String? nickname;
  String? identity;
  String? identityType;
  String? email;
  String? website;
  String? about;
  String? phoneNumber;
  dynamic docImage;
  String? bankName;
  String? bankAccountNumber;
  String? iBAN;
  String? twitterAccount;
  String? facebookAccount;
  String? instagramAccount;
  String? wallet;
  bool? isActive;

  Response(
      {this.id,
        this.nickname,
        this.identity,
        this.identityType,
        this.email,
        this.website,
        this.about,
        this.phoneNumber,
        this.docImage,
        this.bankName,
        this.bankAccountNumber,
        this.iBAN,
        this.twitterAccount,
        this.facebookAccount,
        this.instagramAccount,
        this.wallet,
        this.isActive});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    identity = json['identity'];
    identityType = json['identity_type'];
    email = json['email'];
    website = json['website'];
    about = json['about'];
    phoneNumber = json['phone_number'];
    docImage = json['doc_image'];
    bankName = json['bank_name'];
    bankAccountNumber = json['bank_account_number'];
    iBAN = json['IBAN'];
    twitterAccount = json['twitter_account'];
    facebookAccount = json['facebook_account'];
    instagramAccount = json['instagram_account'];
    wallet = json['wallet'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nickname'] = nickname;
    data['identity'] = identity;
    data['identity_type'] = identityType;
    data['email'] = email;
    data['website'] = website;
    data['about'] = about;
    data['phone_number'] = phoneNumber;
    data['doc_image'] = docImage;
    data['bank_name'] = bankName;
    data['bank_account_number'] = bankAccountNumber;
    data['IBAN'] = iBAN;
    data['twitter_account'] = twitterAccount;
    data['facebook_account'] = facebookAccount;
    data['instagram_account'] = instagramAccount;
    data['wallet'] = wallet;
    data['is_active'] = isActive;
    return data;
  }
}