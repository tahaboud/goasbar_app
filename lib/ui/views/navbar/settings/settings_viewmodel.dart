import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:io';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _mediaService = locator<MediaService>();
  final _bottomSheetService = locator<BottomSheetService>();
  File? file;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  loadData() async {
    setBusy(true);
    Timer(const Duration(milliseconds: 1000), () { setBusy(false); },);
  }

  void pickImage () async {
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
    );

    if (response!.confirmed) {

      notifyListeners();
    }
  }
}