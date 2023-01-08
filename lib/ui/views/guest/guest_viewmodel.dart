import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';

class GuestViewModel extends IndexTrackingViewModel {
  final _tokenService = locator<TokenService>();
  bool? isTokenExist;

  checkToken () async {
    setBusy(true);
    isTokenExist = await _tokenService.isTokenExist();
    setBusy(false);
    notifyListeners();
    return isTokenExist;
  }
}