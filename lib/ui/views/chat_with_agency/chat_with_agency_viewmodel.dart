import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatWithAgencyViewModel extends BaseViewModel {
  ChatWithAgencyViewModel({this.context, });
  BuildContext? context;

  final _navigationService = locator<NavigationService>();
  int indexTab = 1;
  final _fireStore = FirebaseFirestore.instance;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void changeTab(int value) {
    indexTab = value;
    notifyListeners();
  }

  Future sendMessage({String? meId, String? notMeId, TextEditingController? message, chatId}) async {
    if (message!.text.isNotEmpty) {
      await _fireStore.collection("chats").doc(chatId).collection("messages").doc().set({
        "createdAt": DateTime.now(),
        "receiverID": notMeId,
        "senderID": meId,
        "text": message.text,
      });

      message.clear();
      notifyListeners();
    }
  }
}