import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  UserModel? user;

  Future<UserModel?> getUserData() async {
    String token = await _tokenService.getTokenValue();
    setBusy(true);
    return _authService.getUserData(token: token).then((value) {
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
}