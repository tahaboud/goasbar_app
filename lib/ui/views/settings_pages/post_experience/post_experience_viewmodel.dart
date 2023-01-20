import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PostExperienceViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  bool? isCollapsed = false;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void collapse({int? index}) {
    isCollapsed = !isCollapsed!;
    notifyListeners();
  }

  showAddExperienceInfoBottomSheet() async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addExperience,
      isScrollControlled: true,
      barrierDismissible: true,
    );

    if (response!.confirmed) {

      notifyListeners();
    }
  }
}