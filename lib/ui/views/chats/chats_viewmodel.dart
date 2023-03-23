import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatsViewModel extends StreamViewModel<QuerySnapshot<Map<String, dynamic>>> {
  bool isDone = false;
  final _navigationService = locator<NavigationService>();
  final _fireStore = FirebaseFirestore.instance;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return _fireStore
        .collection("chats")
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> get stream => getSnapshots();
}