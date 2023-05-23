import 'dart:async';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/auth_response.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:goasbar/enum/status_code.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpOtpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  AuthResponse? authResponse;
  Timer? _timer;
  int start = 90;
  bool finished = false;
  String? startStr = '1:30';

  void back() {
    _navigationService.back();
  }

  void navigateTo({view}) {
    _navigationService.clearStackAndShowView(view,);
  }

  Future<StatusCode> register({Map<String, dynamic>? body, context, bool? hasImage}) async {
    return await _authService.register(
      context: context,
      hasImage: hasImage,
      body: body,
    ).then((response) {
      if (response == null) {
        return StatusCode.other;
      } else if (response == StatusCode.throttled) {
        return StatusCode.throttled;
      } else {
        authResponse = response;
        _tokenService.setTokenValue(authResponse!.token!);
        notifyListeners();
        return StatusCode.ok;
      }
    });


  }

  Future<bool> verifyPhoneNumber({String? phoneNumber, context}) async {
    return await _authService.verifyPhoneNumber(phoneNumber: phoneNumber, context: context);
  }

  void resendCode({String? phoneNumber, context}) {
    verifyPhoneNumber(phoneNumber: phoneNumber, context: context);
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
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
    },);
  }
}