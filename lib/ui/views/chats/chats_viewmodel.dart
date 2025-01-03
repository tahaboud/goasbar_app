import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/chat_room_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/chat_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatsViewModel extends BaseViewModel {
  ChatsViewModel({
    this.user,
    this.context,
  });
  BuildContext? context;
  UserModel? user;
  List<ChatRoom> rooms = [];

  final _navigationService = locator<NavigationService>();
  final _chatService = locator<ChatApiService>();
  final _tokenService = locator<TokenService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  Future getChatRooms() async {
    List<ChatRoom>? chatRooms = await _chatService.getChatRooms(
        context: context, token: await _tokenService.getTokenValue());
    if (chatRooms != null) {
      rooms = chatRooms;
    } else {
      rooms = [];
    }
    notifyListeners();
  }
}
