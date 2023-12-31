import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatsViewModel extends StreamViewModel<QuerySnapshot<Map<String, dynamic>>> {
  ChatsViewModel({this.user, this.context,});
  BuildContext? context;
  UserModel? user;

  bool isDone = false;
  final _navigationService = locator<NavigationService>();
  final _fireStore = FirebaseFirestore.instance;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return _fireStore
        .collection("chats").where("members", arrayContains: "6", )
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> get stream => getSnapshots();
}