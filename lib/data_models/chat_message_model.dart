import 'package:goasbar/data_models/chat_user_model.dart';

class ChatMessage {
  int id;
  ChatUser sender;
  String message;
  DateTime createdAt;

  ChatMessage(
      {required this.id,
      required this.sender,
      required this.message,
      required this.createdAt});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
        id: json["id"],
        sender: ChatUser.fromJson(json["sender"]),
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]));
  }
}

class StreamChatMessage {
  int sender;
  String message;
  DateTime createdAt;

  StreamChatMessage(
      {required this.sender, required this.message, required this.createdAt});

  factory StreamChatMessage.fromChatMessage(ChatMessage message) {
    return StreamChatMessage(
        sender: message.sender.id,
        message: message.message,
        createdAt: message.createdAt);
  }

  factory StreamChatMessage.fromJson(Map<String, dynamic> json) {
    return StreamChatMessage(
        sender: json["sender"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]));
  }
}
