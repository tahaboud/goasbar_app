import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckoutViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  int? selectedPaymentMethod = 1;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  selectPaymentMethod({int? value}) {
    selectedPaymentMethod = value;
    notifyListeners();
  }
}