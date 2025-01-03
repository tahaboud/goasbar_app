import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatItemViewModel extends FutureViewModel<String?> {
  ChatItemViewModel({this.context});
  BuildContext? context;

  final _navigationService = locator<NavigationService>();
  void navigateTo({view, chatRoomsModel = ChatViewModel}) {
    _navigationService
        .navigateWithTransition(view,
            curve: Curves.easeIn, duration: const Duration(milliseconds: 300))
        ?.then((_) => chatRoomsModel.getChatRooms());
  }

  void back() {
    _navigationService.back();
  }

  @override
  Future<String?> futureToRun() async {
    return "";
  }
}
