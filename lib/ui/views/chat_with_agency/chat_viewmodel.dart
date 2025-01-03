import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/chat_message_model.dart';
import 'package:goasbar/services/chat_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel({
    this.context,
  });
  BuildContext? context;

  List<ChatMessage> messages = [];
  final _navigationService = locator<NavigationService>();
  final _chatService = locator<ChatApiService>();
  final _tokanService = locator<TokenService>();
  int indexTab = 1;
  final _fireStore = FirebaseFirestore.instance;
  WebSocketChannel? channel;

  bool isLoading = false;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future sendMessage(
      {String? meId,
      String? notMeId,
      TextEditingController? message,
      chatId}) async {
    if (message!.text.isNotEmpty) {
      await _fireStore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc()
          .set({
        "createdAt": DateTime.now(),
        "receiverID": notMeId,
        "senderID": meId,
        "text": message.text,
      });

      message.clear();
      notifyListeners();
    }
  }

  Future getRoomMessages(int roomId) async {
    String? token = await _tokanService.getTokenValue();
    List<ChatMessage>? userMessages = await _chatService.getRoomMessages(
        context: context, token: token, roomId: roomId);

    if (userMessages != null) {
      messages = userMessages;
      notifyListeners();
    }
  }

  Future connectToWebSocket(int roomId) async {
    String? token = await _tokanService.getTokenValue();
    channel = IOWebSocketChannel.connect(
        Uri.parse("$baseWebSocketUrl/ws/chat/$roomId/?token=$token"),
        headers: {"origin": "wss://testing.goasbar.com"});
    await channel!.ready;
  }

  void onStart(int roomId) async {
    isLoading = true;
    notifyListeners();
    await connectToWebSocket(roomId);
    await getRoomMessages(roomId);
    isLoading = false;
    notifyListeners();
  }
}
