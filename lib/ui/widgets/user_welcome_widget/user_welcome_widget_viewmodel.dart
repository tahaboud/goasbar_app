import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserWelcomeWidgetViewModel extends FutureViewModel<dynamic> {
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  UserModel? user;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  @override
  Future futureToRun() async {
    String token = await _tokenService.getTokenValue();
    return _authService.getUserData(token: token).then((value) {
      if (value != null) {
        user = value;
        notifyListeners();
        return user;
      } else {
        return null;
      }
    });
  }
}