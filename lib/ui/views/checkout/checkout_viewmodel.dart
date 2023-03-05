import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckoutViewModel extends BaseViewModel {
  static const platform = MethodChannel('Hyperpay.demo.fultter/channel');
  final _navigationService = locator<NavigationService>();
  int? selectedPaymentMethod = 1;
  String? checkoutId;
  final _tokenService = locator<TokenService>();
  final _bookingApiService = locator<BookingApiService>();

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

  Future prepareCheckout({int? bookingId, Map? body, String? cardNumber, String? cardHolder,
    String? expiryMonth, String? expiryYear, String? cVV,}) async {

    String? token = await _tokenService.getTokenValue();
    await _bookingApiService.prepareCheckout(token: token, bookingId: bookingId, body: body,).then((value) {
      if (value != null) {
        pay(bookingId: bookingId, token: token, checkoutId: value, cardHolder: cardHolder, cardNumber: cardNumber,
          cVV: cVV, expiryMonth: expiryMonth, expiryYear: "20$expiryYear", brand: body!['payment_method'],);
      } else {
        print('ya hahahhahahahha');
      }
    });
  }

  Future<String?> pay({int? bookingId, String? token, String? checkoutId, String? cardNumber, String? cardHolder,
      String? expiryMonth, String? expiryYear, String? cVV, String? brand}) async {
    String transactionStatus;
    try {
      final String result = await platform.invokeMethod('gethyperpayresponse', {
        "type": "CustomUI",
        "checkoutid": checkoutId,
        "mode": "TEST",
        "brand": brand == "VISA" ? "DB" : "mada",
        "card_number": cardNumber!.replaceAll(r" ", ""),
        "holder_name": cardHolder,
        "month": expiryMonth,
        "year": expiryYear,
        "cvv": cVV,
        "MadaRegexV": madaRegexV,
        "MadaRegexM": madaRegexM,
        "STCPAY": "disabled",
        "istoken": "false",
        "token": ""
      });
      transactionStatus = '$result';
    } on PlatformException catch (e) {
      transactionStatus = "${e.message}";
    }

    if (transactionStatus != null ||
        transactionStatus == "success" ||
        transactionStatus == "SYNC") {
      _bookingApiService.getPaymentStatus(token: token, bookingId: bookingId);
    } else {
      print("yooooooooooooohooooooooooooooooooo");
    }

    return checkoutId;
  }
}