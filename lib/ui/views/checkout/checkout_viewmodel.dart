import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/cards_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckoutViewModel extends FutureViewModel<CardsModel?> {
  BuildContext? context;
  CheckoutViewModel({this.context});

  static const platform = MethodChannel('Hyperpay.demo.fultter/channel');
  final _navigationService = locator<NavigationService>();
  int? selectedPaymentMethod = 1;
  final _tokenService = locator<TokenService>();
  CardsModel? userCards;
  final _bookingApiService = locator<BookingApiService>();
  bool? waitUntilFinish = false;
  bool? isClicked = false;
  Response? selectedRegisteredCard = Response(registrationId: "");

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  updateIsRegisteredCardSelected({registeredCard}) {
    if (selectedRegisteredCard!.registrationId == "") {
      selectedRegisteredCard = registeredCard;
    } else {
      selectedRegisteredCard = Response(registrationId: "");
    }
    notifyListeners();
  }

  selectPaymentMethod({int? value}) {
    selectedPaymentMethod = value;
    notifyListeners();
  }

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  Future prepareCheckoutTokenization(
      {context,
      cvv,
      int? bookingId,
      Map? body,
      registrationId,
      brand,
      user}) async {
    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    await _bookingApiService
        .prepareCheckout(
      context: context,
      token: token,
      bookingId: bookingId,
      body: body,
    )
        .then((value) async {
      updateIsClicked(value: false);
    });
  }

  Future prepareCheckoutApplePayment({
    context,
    UserModel? user,
    int? bookingId,
    Map? body,
  }) async {
    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    await _bookingApiService
        .prepareCheckout(
      context: context,
      token: token,
      bookingId: bookingId,
      body: body,
    )
        .then((value) {
      updateIsClicked(value: false);
    });
  }

  Future prepareCheckoutPayment({
    context,
    UserModel? user,
    int? bookingId,
    Map? body,
    String? cardNumber,
    String? cardHolder,
    String? expiryMonth,
    String? expiryYear,
    String? cVV,
  }) async {
    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    await _bookingApiService
        .prepareCheckout(
      context: context,
      token: token,
      bookingId: bookingId,
      body: body,
    )
        .then((value) {
      updateIsClicked(value: false);
      if (value != null) {
        platform.invokeMethod("gethyperpayresponse", <String, dynamic>{
          "checkoutId": value,
          "type": "CustomUI",
          "mode": "LIVE",
          "lang": "en_us",
          "ShopperResultUrl": "goasbar://result",
          "brand": "VISA",
          "card_number": cardNumber,
          "holder_name": cardHolder,
          "year": "20$expiryYear",
          "month": expiryMonth,
          "cvv": cVV,
          "EnabledTokenization": "false",
        }).then((value) {
          if (value == "SYNC") {
            _bookingApiService.getPaymentStatus(
              context: context,
              token: token,
              bookingId: bookingId,
            );
          }
        }).catchError((e) {});
      }
    });
  }

  Future payWithCard(
      {context,
      UserModel? user,
      int? bookingId,
      String? token,
      String? checkoutId,
      String? cardNumber,
      String? cardHolder,
      String? expiryMonth,
      String? expiryYear,
      String? cVV,
      String? brand}) async {
    payWithCardCustomUi(
      user: user,
      context: context,
      bookingId: bookingId,
      token: token,
      cardNumber: cardNumber!,
      brandName: brand!,
      checkoutId: checkoutId!,
      cvv: cVV as String,
      holderName: cardHolder,
      month: expiryMonth as String,
      year: expiryYear as String,
    );
  }

  payWithCardCustomUi(
      {required String brandName,
      String? holderName,
      String? month,
      String? year,
      String? cvv,
      context,
      UserModel? user,
      int? bookingId,
      String? token,
      required String checkoutId,
      required String cardNumber}) async {
    platform.invokeMethod("gethyperpayresponse", <String, dynamic>{
      "checkoutId": checkoutId,
      "type": "CustomUI",
      "mode": "LIVE",
      "lang": "en_us",
      "ShopperResultUrl": "goasbar://result",
      "brand": brandName,
      "card_number": cardNumber,
      "holder_name": holderName,
      "year": year,
      "month": month,
      "cvv": cvv,
      "EnabledTokenization": "false",
    }).then((value) {
      return value;
    }).catchError((e) {});
  }

  @override
  Future<CardsModel?> futureToRun() async {
    // return getUserCards();
    return CardsModel();
  }
}

class InAppPaymentSetting {
  static const String shopperResultUrl = "goasbar://result";
  static const String merchantId = "merchant.com.goasbar.goAsbarApp";
  static const String countryCode = "SA";
  static getLang() {
    if (Platform.isIOS) {
      return "en"; // ar
    } else {
      return "en_US"; // ar_AR
    }
  }
}
