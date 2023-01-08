import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  bool isDone = false;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();

  startAnimation() async {
    Timer(const Duration(milliseconds: 1000), () async { isDone = true; notifyListeners(); },);
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  checkToken () async {
    return await _tokenService.isTokenExist();
  }
}