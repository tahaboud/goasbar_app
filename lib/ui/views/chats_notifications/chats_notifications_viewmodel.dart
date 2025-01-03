import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/chat_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatsNotificationsViewModel extends FutureViewModel<String?> {
  ChatsNotificationsViewModel({this.context});
  BuildContext? context;

  final _navigationService = locator<NavigationService>();
  int indexTab = 1;
  String? userToken;

  final _chatApiService = locator<ChatApiService>();
  final _tokenService = locator<TokenService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void changeTab(int value) {
    indexTab = value;
    notifyListeners();
  }

  Future<String?> getUserFireStoreToken() async {
    String? token = await _tokenService.getTokenValue();
    notifyListeners();
    return "";
  }

  @override
  Future<String?> futureToRun() {
    return getUserFireStoreToken();
  }
}
