import 'dart:async';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/connectivity_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  final _connectivityService = locator<ConnectivityService>();
  UserModel? user;
  bool? thereIsConnection = true;

  Future<UserModel?> getUserData({context}) async {
    String? token = await _tokenService.getTokenValue();
    setBusy(true);
    return _authService.getUserData(token: token, context: context).then((value) {
      if (value != null) {
        user = value;
        notifyListeners();
        setBusy(false);
        return user;
      } else {
        setBusy(false);
        return null;
      }
    });
  }

  getConnectivityStatus({context}) {
    _connectivityService.checkConnectivity(() {
      getUserData(context: context);
      thereIsConnection = true;
      notifyListeners();
    }, () {
      thereIsConnection = false;
      notifyListeners();
    });
  }
}