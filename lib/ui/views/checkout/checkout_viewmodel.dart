import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/bookings_history/bookings_history_view.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:hyperpay_plugin/flutter_hyperpay.dart';

class CheckoutViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  int? selectedPaymentMethod = 1;
  String? checkoutId;
  final _tokenService = locator<TokenService>();
  final _dialogService = locator<DialogService>();
  final _bookingApiService = locator<BookingApiService>();
  bool? waitUntilFinish = false;
  bool? isClicked = false;
  FlutterHyperPay? flutterHyperPay;

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

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  Future prepareCheckout({context, UserModel? user, int? bookingId, Map? body, String? cardNumber, String? cardHolder,
    String? expiryMonth, String? expiryYear, String? cVV,}) async {

    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    await _bookingApiService.prepareCheckout(context: context, token: token, bookingId: bookingId, body: body,).then((value) {
      updateIsClicked(value: false);
      if (value != null) {
        pay(context: context, user: user, bookingId: bookingId, token: token, checkoutId: value, cardHolder: cardHolder, cardNumber: cardNumber,
          cVV: cVV, expiryMonth: expiryMonth, expiryYear: "20$expiryYear", brand: body!['payment_method'],);
      }
    });
  }

  Future pay({context, UserModel? user, int? bookingId, String? token, String? checkoutId,
    String? cardNumber, String? cardHolder, String? expiryMonth, String? expiryYear,
    String? cVV, String? brand}) async {

    flutterHyperPay = FlutterHyperPay(
      shopperResultUrl: InAppPaymentSetting.shopperResultUrl,
      paymentMode:  PaymentMode.live,
      lang: InAppPaymentSetting.getLang(),
    );

    payRequestNowCustomUi(
      user: user,
      context: context,
      bookingId: bookingId,
      token: token,
      cardNumber: cardNumber!,
      brandName: brand!,
      checkoutId: checkoutId!,
      cvv: int.parse(cVV!),
      holderName: cardHolder,
      month: int.parse(expiryMonth!),
      year: int.parse(expiryYear!),
    );
  }

  payRequestNowCustomUi(
      {required String brandName, String? holderName, int? month, int? year, int? cvv,
        context, UserModel? user, int? bookingId, String? token,
        required String checkoutId , required String cardNumber}) async {
    PaymentResultData paymentResultData;

    paymentResultData = await flutterHyperPay!.customUICards(
      customUI: CustomUI(
        brandName: "VISA",
        checkoutId: checkoutId,
        cardNumber: "4890222038275348",
        holderName: "OSAMA MOGAITOOF",
        month: 11,
        year: 2025,
        cvv: 719,
        enabledTokenization: false, // default
      ),
    );

    if (paymentResultData.paymentResult == PaymentResult.success ||
        paymentResultData.paymentResult == PaymentResult.sync) {

      print('-------------------------------------');
      print('DONE');

      _dialogService.showCustomDialog(variant: DialogType.waitingUntilPaymentFinished, barrierDismissible: false, );

      bool? bookingState = await _bookingApiService.getPaymentStatus(context: context, token: token, bookingId: bookingId);
      if (bookingState!) {
        Navigator.pop(context);
        _navigationService.clearTillFirstAndShowView(BookingsHistoryView(user: user!, ));
      } else {
        Navigator.pop(context);
        // showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
      }
    } else {
      showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
    }
  }
}

class InAppPaymentSetting {
  static const String shopperResultUrl= "goasbar";
  static getLang() {
    if (Platform.isIOS) {
      return  "en"; // ar
    } else {
      return "en_US"; // ar_AR
    }
  }
}