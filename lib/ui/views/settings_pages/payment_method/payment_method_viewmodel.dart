import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/cards_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PaymentMethodViewModel extends FutureViewModel<CardsModel?> {
  BuildContext? context;
  PaymentMethodViewModel({this.context});

  bool isDone = false;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  CardsModel? userCards;

  Future navigateTo({view}) async{
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  checkToken () async {
    return await _tokenService.isTokenExist();
  }

  Future<CardsModel?> getUserCards () async {
    String? token = await _tokenService.getTokenValue();
    return _authService.getUserCards(context: context, token: token).then((value) {
      if (value != null) {
        userCards = value;
        notifyListeners();
      }
      return userCards;
    });
  }

  @override
  Future<CardsModel?> futureToRun() {
    return getUserCards();
  }
}