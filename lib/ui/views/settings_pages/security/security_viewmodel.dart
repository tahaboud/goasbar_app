import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SecurityViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  bool isObscure = true;

  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  String? validatePassword ({String? value}) {
    return _validationService.passwordValidation(value);
  }
}