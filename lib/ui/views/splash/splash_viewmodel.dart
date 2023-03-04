import 'dart:async';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends FutureViewModel<dynamic> {
  bool isDone = false;
  bool isDone2 = false;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();

  void clearStackAndShowView({view}) {
    _navigationService.clearStackAndShowView(view,);
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
        clearStackAndShowView(view: const HomeView(isUser: true));
      },);
    } else {
      Timer(const Duration(milliseconds: 2000), () async {
        isDone2 = true;
        notifyListeners();
      },);
    }
    setBusy(false);
    return await checkToken();
  }
}