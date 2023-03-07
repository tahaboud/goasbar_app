import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TripItemViewModel extends FutureViewModel<bool?> {
  final UserModel? user;
  final ExperienceResults? experience;
  TripItemViewModel({this.user, this.experience});

  bool isFav = false;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  final _bottomSheetService = locator<BottomSheetService>();
  List<int>? favoriteList = [];

  void addFavorites({int? experienceId}) {
    isFav = !isFav;
    updateUserData(experienceId: experienceId, isRemove: isFav);
    notifyListeners();
  }

  updateUserData({int? experienceId, bool? isRemove}) async {
    String token = await _tokenService.getTokenValue();
    notifyListeners();

    favoriteList = user!.favoriteExperiences;

    if (!isRemove!) {
      if (favoriteList!.contains(experienceId!)) favoriteList!.remove(experienceId);
    } else {
      if (!favoriteList!.contains(experienceId!)) favoriteList!.add(experienceId);
    }

    notifyListeners();
    _authService.updateFavoritesUser(token: token, body: {
      "favorite_experiences": favoriteList,
    },);
  }

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

  bool getIsFav () {
    favoriteList = user!.favoriteExperiences;
    isFav = favoriteList!.contains(experience!.id);
    notifyListeners();

    return isFav;
  }

  @override
  Future<bool?> futureToRun() async {
    return getIsFav();
  }
}