import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingItemForProviderViewModel extends BaseViewModel {
  final UserModel? user;
  BookingItemForProviderViewModel({this.user, });

  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  List<int>? favoriteList = [];

  navigateTo({view}) async {
    await _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  Future showReviewBottomSheet() async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.review,
      isScrollControlled: true,
      barrierDismissible: true,
      data: user,
    );

    if (response!.confirmed) {
      return true;
    }
  }
}