import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  bool isObscure = true;
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _authService = locator<AuthService>();
  bool? isClicked = false;

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void back() {
    _navigationService.back();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  String? validatePhoneNumber({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  Future<bool> verifyPhoneNumber({String? phoneNumber, context}) async {
    updateIsClicked(value: true);
    return await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber, context: context);
  }
}
