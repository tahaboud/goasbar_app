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
import 'package:http/http.dart' as http;

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

    // Access token can be taken from the backend UI under Administration > Account data > Merchant / Channel Info
    // Live: https://eu-prod.oppwa.com/
    //TODO payment with test data
    // http.post(Uri.parse("https://eu-test.oppwa.com/v1/payments"),
    //     headers: {
    //       "Authorization": "Bearer OGE4Mjk0MTc0YjdlY2IyODAxNGI5Njk5MjIwMDE1Y2N8c3k2S0pzVDg=",
    //     },
    //     body: {
    //       "entityId": "8a8294174b7ecb28014b9699220015ca",
    //       "amount": "2.00",
    //       "currency": "EUR",
    //       "paymentBrand": "VISA",
    //       "card.number":"4200000000000000",
    //       "card.holder":"Jane Jones",
    //       "paymentType": brand == "VISA" ? "DB" : "mada",
    //       "card.expiryMonth": expiryMonth,
    //       "card.expiryYear": expiryYear,
    //       "card.cvv": cVV,
    //     }
    // ).then((value) {
    //   print(value.body);
    //
    // });

    http.post(Uri.parse("https://eu-test.oppwa.com/v1/payments"),
      body: {
        "type": "CustomUI",
        "checkoutid": checkoutId,
        "mode": "LIVE",
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
      }
    );
    try {
      final String result = await platform.invokeMethod('gethyperpayresponse', {

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