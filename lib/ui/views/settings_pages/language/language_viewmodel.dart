import 'package:easy_localization/easy_localization.dart';
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

  changeValue({String? value, BuildContext? context}) {
    if (context!.locale == const Locale('ar', 'SA')) {
      context.setLocale(const Locale('en', 'UK'));
    } else {
      context.setLocale(const Locale('ar', 'SA'));
    }

    lang = value;
    notifyListeners();
  }

  getStartLocale({BuildContext? context}) {
    setBusy(true);
    lang = context!.locale == const Locale('ar', 'SA') ? "ar" : "uk";
    notifyListeners();
    setBusy(false);
  }
}