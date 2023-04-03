import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/auth_response.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  bool isObscure = true;
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  AuthResponse? authResponse;
  bool? isClicked = false;

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view,);
  }


  String? validatePassword ({String? value}) {
    return _validationService.passwordValidation(value);
  }

  setToken ({token}) {
    _tokenService.setTokenValue(token);
  }

  Future<bool> login({Map? body}) async {
    updateIsClicked(value: true);
    authResponse = await _authService.login(
      body: body,
    );
    if (authResponse!.token != null) {
      _tokenService.setTokenValue(authResponse!.token!);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}