import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LanguageViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  String? lang = "uk";

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  changeValue({String? value}) {
    lang = value;
    notifyListeners();
  }
}