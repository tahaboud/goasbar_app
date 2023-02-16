import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:io';

class SettingsViewModel extends FutureViewModel<dynamic> {
  final _navigationService = locator<NavigationService>();
  final _mediaService = locator<MediaService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  File? file;
  UserModel? user;
  ProviderModel? provider;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view);
  }

  void back() {
    _navigationService.back();
  }

  loadData() async {
    setBusy(true);
    Timer(const Duration(milliseconds: 1000), () { setBusy(false); },);
  }

  Future pickImage () async {
    file = await _mediaService.getImage();
    if (file != null) {
      notifyListeners();
    }
  }

  showGeneralInfoBottomSheet() async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.beHosted,
      isScrollControlled: true,
      barrierDismissible: true,
      data: user,
    );

    notifyListeners();
  }

  Future<bool> logout() async {
    return _authService.logout(token: await _tokenService.getTokenValue());
  }

  clearToken () {
    _tokenService.clearToken();
  }

  Future<dynamic> getUserInfo() async {
    String token = await _tokenService.getTokenValue();
    user = await _authService.getUserData(token: token).then((value) {
      if (value != null) {
        user = value;
        notifyListeners();
        return user;
      } else {
        return null;
      }
    });


  }

  @override
  Future futureToRun() {
    return getUserInfo();
  }
}