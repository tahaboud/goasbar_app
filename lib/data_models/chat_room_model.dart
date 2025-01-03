import 'package:goasbar/data_models/chat_user_model.dart';

class ChatRoom {
  int id;
  ChatUser client;
  ChatUser provider;
  DateTime createdAt;
  DateTime? lastMessageDate;
  int unreadMessagesCount;

  ChatRoom(
      {required this.id,
      required this.client,
      required this.provider,
      required this.createdAt,
      required this.lastMessageDate,
      required this.unreadMessagesCount});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json["id"],
      client: ChatUser.fromJson(json["client"]),
      provider: ChatUser.fromJson(json["provider"]),
      createdAt: DateTime.parse(json["created_at"]),
      lastMessageDate: json["last_message_date"] != null
          ? DateTime.parse(json["last_message_date"])
          : null,
      unreadMessagesCount: json["unread_messages_count"],
    );
  }
}
