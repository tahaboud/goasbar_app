import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/cards_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:hyperpay_plugin/flutter_hyperpay.dart';

class CheckoutViewModel extends FutureViewModel<CardsModel?> {
  BuildContext? context;
  CheckoutViewModel({this.context});

  static const platform = MethodChannel('Hyperpay.demo.fultter/channel');
  final _navigationService = locator<NavigationService>();
  int? selectedPaymentMethod = 1;
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  CardsModel? userCards;
  final _dialogService = locator<DialogService>();
  final _bookingApiService = locator<BookingApiService>();
  bool? waitUntilFinish = false;
  bool? isClicked = false;
  FlutterHyperPay? flutterHyperPay;
  Response? selectedRegisteredCard = Response(registrationId: "");

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
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

  Future prepareCheckoutTokenization({context, cvv, int? bookingId, Map? body, registrationId, brand, user}) async {
    print(body);
    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    await _bookingApiService.prepareCheckout(context: context, token: token, bookingId: bookingId, body: body,).then((value) async{
      updateIsClicked(value: false);
      if (value != null) {
        print(brand);
        print(cvv);
        print(value);
        print(registrationId);

        try {

          flutterHyperPay = FlutterHyperPay(
            shopperResultUrl: InAppPaymentSetting.shopperResultUrl,
            paymentMode:  PaymentMode.live,
            lang: InAppPaymentSetting.getLang(),
          );

          if (Platform.isIOS) {
            PaymentResultData paymentResultData = await flutterHyperPay!.payWithSoredCards(
              storedCards: StoredCards(
                checkoutId: value,
                cvv: cvv,
                tokenId: registrationId,
                brandName: brand,
                paymentType: "DB",
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
                _navigationService.clearTillFirstAndShowView(const HomeView(isUser: true,));
              } else {
                Navigator.pop(context);
              }
            } else {
              showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
            }
          } else {
            final String result = await platform.invokeMethod('paywithsavedcard', {
              "checkoutid": value,
              "brand": brand,
              "tokenid": registrationId,
              "cvv": cvv,
            }).then((value) {
              print(value);
              return value;
            });
            print(result);
            if (result == "SYNC") {

              print('-------------------------------------');
              print('DONE');

              _dialogService.showCustomDialog(variant: DialogType.waitingUntilPaymentFinished, barrierDismissible: false, );

              bool? bookingState = await _bookingApiService.getPaymentStatus(context: context, token: token, bookingId: bookingId);
              print(bookingId);
              if (bookingState!) {
                Navigator.pop(context);
                _navigationService.clearTillFirstAndShowView(const HomeView(isUser: true,));
              } else {
                Navigator.pop(context);
              }
            } else {
              showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
            }
          }

        } on PlatformException catch (e) {
          print(e);

        }
      }
    });
  }

  Future prepareCheckoutApplePayment({context, UserModel? user, int? bookingId, Map? body,}) async {

    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    print(body);
    await _bookingApiService.prepareCheckout(context: context, token: token, bookingId: bookingId, body: body,).then((value) {
      updateIsClicked(value: false);
      if (value != null) {
        flutterHyperPay = FlutterHyperPay(
          shopperResultUrl: InAppPaymentSetting.shopperResultUrl,
          paymentMode:  PaymentMode.live,
          lang: InAppPaymentSetting.getLang(),
        );

        payRequestNowReadyUI(checkoutId: value, context: context, token: token, user: user, bookingId: bookingId);
      }
    });
  }

  Future prepareCheckoutPayment({context, UserModel? user, int? bookingId, Map? body, String? cardNumber, String? cardHolder,
    String? expiryMonth, String? expiryYear, String? cVV,}) async {

    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    print(body);
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

  payRequestNowReadyUI({required String checkoutId, context, UserModel? user, int? bookingId, String? token,}) async {
    PaymentResultData paymentResultData;
    paymentResultData = await flutterHyperPay!.readyUICards(
      readyUI: ReadyUI(
          brandsName: ["MADA", "VISA" ,"MASTER", "APPLEPAY"],
          checkoutId: checkoutId,
          merchantIdApplePayIOS: InAppPaymentSetting.merchantId, // applepay
          countryCodeApplePayIOS: InAppPaymentSetting.countryCode, // applePay
          companyNameApplePayIOS: "Go Asbar", // applePay
          themColorHexIOS: "#000000",// FOR IOS ONLY
          setStorePaymentDetailsMode: false, // store payment details for future use
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
        _navigationService.clearTillFirstAndShowView(const HomeView(isUser: true,));
      } else {
        Navigator.pop(context);
      }
    } else {
      showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
    }
  }

  payRequestNowCustomUi(
      {required String brandName, String? holderName, int? month, int? year, int? cvv,
        context, UserModel? user, int? bookingId, String? token,
        required String checkoutId , required String cardNumber}) async {
    PaymentResultData paymentResultData;

    flutterHyperPay = FlutterHyperPay(
      shopperResultUrl: InAppPaymentSetting.shopperResultUrl,
      paymentMode:  PaymentMode.live,
      lang: InAppPaymentSetting.getLang(),
    );

    if (Platform.isIOS) {
      // final String result = await platform.invokeMethod('savecard', {
      //   "checkoutid": value,
      //   "number": cardNumber,
      //   "brand": cardType,
      //   "holder": cardHolder!.replaceAll(" ", ""),
      //   "expiryMonth": expiryMonth,
      //   "expiryYear": "20$expiryYear",
      //   "cvv": cVV,
      // });
      // updateIsClicked(value: false);
      // print(result);
      paymentResultData = await flutterHyperPay!.readyUICards(
        readyUI: ReadyUI(
          brandsName: [ "VISA" , "MASTER" , "MADA" ,"APPLEPAY"],
          checkoutId: checkoutId,
          merchantIdApplePayIOS: InAppPaymentSetting.merchantId, // applepay
          countryCodeApplePayIOS: InAppPaymentSetting.countryCode, // applePay
          companyNameApplePayIOS: "Go Asbar", // applePay
          themColorHexIOS: "#000000",// FOR IOS ONLY
          setStorePaymentDetailsMode: false,
        ),
      );
    } else {
      paymentResultData = await flutterHyperPay!.customUICards(
        customUI: CustomUI(
          brandName: brandName,
          checkoutId: checkoutId,
          cardNumber: cardNumber.replaceAll(" ", ""),
          holderName: holderName!,
          month: month!,
          year: year!,
          cvv: cvv!,
          enabledTokenization: false, // default
        ),
      );
    }

    if (paymentResultData.paymentResult == PaymentResult.success ||
        paymentResultData.paymentResult == PaymentResult.sync) {

      print('-------------------------------------');
      print('DONE');

      _dialogService.showCustomDialog(variant: DialogType.waitingUntilPaymentFinished, barrierDismissible: false, );

      bool? bookingState = await _bookingApiService.getPaymentStatus(context: context, token: token, bookingId: bookingId);
      if (bookingState!) {
        Navigator.pop(context);
        _navigationService.clearTillFirstAndShowView(const HomeView(isUser: true,));
      } else {
        Navigator.pop(context);
      }
    } else {
      showMotionToast(context: context, title: 'Error Payment', msg: "Payment Failed, Please Retry Payment", type: MotionToastType.error);
    }
  }

  // Future<CardsModel?> getUserCards () async {
  //   String? token = await _tokenService.getTokenValue();
  //   return _authService.getUserCards(context: context, token: token).then((value) {
  //     if (value != null) {
  //       userCards = value;
  //       notifyListeners();
  //     }
  //     return userCards;
  //   });
  // }

  @override
  Future<CardsModel?> futureToRun() async {
    // return getUserCards();
    return CardsModel();
  }
}

class InAppPaymentSetting {
  static const String shopperResultUrl= "goasbar";
  static const String merchantId= "merchant.com.goasbar.goAsbarApp";
  static const String countryCode="SA";
  static getLang() {
    if (Platform.isIOS) {
      return  "en"; // ar
    } else {
      return "en_US"; // ar_AR
    }
  }
}