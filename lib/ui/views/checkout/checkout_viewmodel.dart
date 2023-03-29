import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/bookings_history/bookings_history_view.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckoutViewModel extends BaseViewModel {
  static const platform = MethodChannel('Hyperpay.demo.fultter/channel');
  final _navigationService = locator<NavigationService>();
  int? selectedPaymentMethod = 1;
  String? checkoutId;
  final _tokenService = locator<TokenService>();
  final _dialogService = locator<DialogService>();
  final _bookingApiService = locator<BookingApiService>();
  bool? waitUntilFinish = false;
  bool? isClicked = false;

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

  Future<String?> pay({context, UserModel? user, int? bookingId, String? token, String? checkoutId, String? cardNumber, String? cardHolder,
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

      _dialogService.showCustomDialog(variant: DialogType.waitingUntilPaymentFinished, barrierDismissible: false, );

      bool? bookingState = await _bookingApiService.getPaymentStatus(context: context, token: token, bookingId: bookingId);
      if (bookingState!) {
        Navigator.pop(context);
        //TODO go to bookings page
        _navigationService.clearTillFirstAndShowView(BookingsHistoryView(user: user!, ));
      } else {
        Navigator.pop(context);
        showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
      }
    } else {
      showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
    }

    return checkoutId;
  }
}