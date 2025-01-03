import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/chat_message_model.dart';
import 'package:goasbar/data_models/chat_room_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';

class ChatApiService {
  final _authService = locator<AuthService>();

  Future<List<ChatRoom>?> getChatRooms({context, String? token}) async {
    return http.get(
      Uri.parse("$baseUrl/api/chat/rooms/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        List<ChatRoom> rooms = [];
        jsonDecode(utf8.decode(response.bodyBytes)).forEach((room) {
          rooms.add(ChatRoom.fromJson(room));
        });
        return rooms;
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Connection Failed',
            msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
                ['detail'],
            type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<List<ChatMessage>?> getRoomMessages(
      {context, String? token, required int roomId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/chat/rooms/$roomId/messages/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        List<ChatMessage> messages = [];
        jsonDecode(utf8.decode(response.bodyBytes)).forEach((message) {
          messages.add(ChatMessage.fromJson(message));
        });
        return messages;
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        return null;
      }
    });
  }
}
