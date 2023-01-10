import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TripsViewModel extends BaseViewModel {
  int index = 1;
  final _navigationService = locator<NavigationService>();

  void selectCategory({ind}) {
    index = ind;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  loadData() async {
    setBusy(true);
    Timer(const Duration(milliseconds: 1000), () { setBusy(false); },);
  }
}