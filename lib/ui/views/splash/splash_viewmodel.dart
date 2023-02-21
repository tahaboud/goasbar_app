import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends FutureViewModel<dynamic> {
  bool isDone = false;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  checkToken () async {
    return await _tokenService.isTokenExist();
  }

  startAnimation() async {
    Timer(const Duration(milliseconds: 1000), () async {
      isDone = true;
      notifyListeners();
    },);
  }

  @override
  Future<bool?> futureToRun() async {
    setBusy(true);
    if (await checkToken()) {
      Timer(const Duration(milliseconds: 2500), () async {
        navigateTo(view: const HomeView());
      },);
    }
    setBusy(false);
    return await checkToken();
  }
}