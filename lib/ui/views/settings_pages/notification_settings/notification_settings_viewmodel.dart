import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationSettingsViewModel extends BaseViewModel {
  bool genInfo = true;
  bool sound = false;
  bool vibrate = true;
  bool bill = true;
  bool promotion = true;
  bool appUpdates = false;
  bool discount = false;
  bool payment = false;
  bool newService = false;
  bool newTips = true;
  final _navigationService = locator<NavigationService>();

  void changeValue({int? number, bool? value}) {
    switch(number) {
      case 1:
        genInfo = value!;
        break;
      case 2:
        sound = value!;
        break;
      case 3:
        vibrate = value!;
        break;
      case 4:
        appUpdates = value!;
        break;
      case 5:
        bill = value!;
        break;
      case 6:
        promotion = value!;
        break;
      case 7:
        discount = value!;
        break;
      case 8:
        payment = value!;
        break;
      case 9:
        newService = value!;
        break;
      case 10:
        newTips = value!;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }
}