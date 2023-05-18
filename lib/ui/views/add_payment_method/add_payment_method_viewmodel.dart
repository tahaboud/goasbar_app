import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddPaymentMethodViewModel extends BaseViewModel {
  static const platform = MethodChannel('Hyperpay.demo.fultter/channel');
  int? selectedCardType = 1;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  changeSelection({index}) {
    selectedCardType = index;
    notifyListeners();
  }

  Future<String?> saveCard({String? cardType, cardNumber, String? cardHolder, cVV, expiryMonth, expiryYear, context}) async {
    String? token = await _tokenService.getTokenValue();
    await _authService.getRegistrationId(body: {"card_type": cardType,}, context: context, token: token).then((value) async {
      try {
        final String result = await platform.invokeMethod('savecard', {
          "checkoutid": value,
          "number": cardNumber,
          "brand": cardType,
          "holder": cardHolder!.replaceAll(" ", ""),
          "expiryMonth": expiryMonth,
          "expiryYear": "20$expiryYear",
          "cvv": cVV,
        });
        print(result);



        _authService.getRegistrationStatus(id: value, context: context, token: token, cardType: cardType);
      } on PlatformException catch (e) {

      }
    });
  }
}