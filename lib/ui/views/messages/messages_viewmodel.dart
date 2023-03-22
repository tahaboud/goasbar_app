import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MessagesViewModel extends StreamViewModel<QuerySnapshot<Map<String, dynamic>>> {
  bool isDone = false;
  final _navigationService = locator<NavigationService>();
  final _fireStore = FirebaseFirestore.instance;

  startAnimation() async {
    Timer(const Duration(milliseconds: 1000), () async { isDone = true; notifyListeners(); },);
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  loadData() async {
    setBusy(true);
    Timer(const Duration(milliseconds: 1000), () { setBusy(false); },);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return _fireStore
        .collection("chats")
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> get stream => getSnapshots();
}