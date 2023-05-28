import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/chat_token_provider_model.dart';
import 'package:goasbar/services/chat_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatWithAgencyFromTripDetailViewModel extends FutureViewModel<ChatTokenProviderModel?> {
  ChatWithAgencyFromTripDetailViewModel({this.context, this.providerId});
  BuildContext? context;
  int? providerId;

  final _navigationService = locator<NavigationService>();
  final _chatApiService = locator<ChatApiService>();
  final _tokenService = locator<TokenService>();
  ChatTokenProviderModel? chatTokenProvider;
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

  Future<ChatTokenProviderModel?> getUserFireStoreTokenAndProviderChatId() async {
    String? token = await _tokenService.getTokenValue();
    chatTokenProvider = await _chatApiService.getProviderFireStoreTokenAndChatId(context: context, token: token, providerId: providerId);
    notifyListeners();
    return await auth(token: chatTokenProvider!.fireStoreToken).then((value) {
      if (value != null) {
        return chatTokenProvider;
      } else {
        return null;
      }
    });
  }

  Future<UserCredential?> auth({token}) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCustomToken(token);
      print("Sign-in successful.");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-custom-token":
          print("The supplied token is not a Firebase custom auth token.");
          return null;
        case "custom-token-mismatch":
          print("The supplied token is for a different Firebase project.");
          return null;
        default:
          print("Unkown error.");
          return null;
      }
    }
  }

  Future sendMessage({String? meId, String? notMeId, TextEditingController? message,}) async {
    if (message!.text.isNotEmpty) {
      await _fireStore.collection("chats").doc(chatTokenProvider!.chatId).collection("messages").doc().set({
        "createdAt": DateTime.now(),
        "receiverID": notMeId,
        "senderID": meId,
        "text": message.text,
      });

      message.clear();
      notifyListeners();
    }
  }

  @override
  Future<ChatTokenProviderModel?> futureToRun() async {
    return await getUserFireStoreTokenAndProviderChatId();
  }
}