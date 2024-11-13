import 'dart:async';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/auth_response.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpOtpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  AuthResponse? authResponse;
  int start = 90;
  bool finished = false;
  String? startStr = '1:30';

  void back() {
    _navigationService.back();
  }

  void navigateTo({view}) {
    _navigationService.clearStackAndShowView(
      view,
    );
  }

  Future<String> checkVerificationCode(
      {Map<String, dynamic>? body, context}) async {
    return await _authService
        .checkVerificationCode(
      context: context,
      body: body,
    )
        .then((response) {
      return response;
    });
  }

  Future<String> verifyPhoneNumber({String? phoneNumber, context}) async {
    return await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber, context: context);
  }

  void resendCode({String? phoneNumber, context}) {
    verifyPhoneNumber(phoneNumber: phoneNumber, context: context);
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          finished = true;
          start = 90;
          startStr = '1:30';
          notifyListeners();
        } else {
          start--;
          if (start > 59) {
            if (start - 60 < 10) {
              startStr = "1:0${start - 60}";
            } else {
              startStr = "1:${start - 60}";
            }
          } else {
            if (start < 10) {
              startStr = "0:0$start";
            } else {
              startStr = "0:$start";
            }
          }
          notifyListeners();
        }
      },
    );
  }
}
