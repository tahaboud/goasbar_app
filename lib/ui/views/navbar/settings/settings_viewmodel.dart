import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends FutureViewModel<UserModel?> {
  BuildContext? context;
  bool? isUser;
  SettingsViewModel({this.context, this.isUser});

  final _navigationService = locator<NavigationService>();
  final _mediaService = locator<MediaService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  File? file;
  ProviderModel? provider;
  bool? isClicked = false;
  bool? isClicked2 = false;
  UserModel? user;

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  updateIsClicked2({value}) {
    isClicked2 = value;
    notifyListeners();
  }

  void navigateToWithResponse({view}) {
    _navigationService
        .navigateWithTransition(view,
            curve: Curves.easeIn, duration: const Duration(milliseconds: 300))!
        .then((value) {
      futureToRun();
    });
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view);
  }

  void back() {
    _navigationService.back();
  }

  Future pickImage() async {
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

    if (response!.confirmed) {
      futureToRun();
    }

    notifyListeners();
  }

  Future<bool?> logout({context}) async {
    updateIsClicked(value: true);
    return _authService.logout(
        context: context, token: await _tokenService.getTokenValue());
  }

  Future<bool?> deleteAccount({context}) async {
    updateIsClicked2(value: true);
    return _authService.deleteAccount(
        context: context, token: await _tokenService.getTokenValue());
  }

  clearToken() {
    _tokenService.clearToken();
  }

  Future<UserModel?> getUserData() async {
    String? token = await _tokenService.getTokenValue();
    user = await _authService.getUserData(token: token, context: context);
    notifyListeners();
    return user;
  }

  @override
  Future<UserModel?> futureToRun() async {
    return isUser! ? await getUserData() : null;
  }
}
