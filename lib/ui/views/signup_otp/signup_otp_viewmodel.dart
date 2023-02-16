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

  void back() {
    _navigationService.back();
  }

  void navigateTo({view}) {
    _navigationService.clearStackAndShowView(view,);
  }

  Future<StatusCode> register({Map? body}) async {
    dynamic response = await _authService.register(
      body: body,
    );
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
  }
}