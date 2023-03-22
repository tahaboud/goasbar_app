class ChatTokenProviderModel {
  String? chatId;
  String? fireStoreToken;

  ChatTokenProviderModel({this.chatId, this.fireStoreToken});

  ChatTokenProviderModel.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    fireStoreToken = json['firestore_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['firestore_token'] = fireStoreToken;
    return data;
  }
}