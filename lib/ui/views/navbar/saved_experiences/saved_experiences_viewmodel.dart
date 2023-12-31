import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SavedExperiencesViewModel
    extends FutureViewModel<List<ExperienceResults?>> {
  final UserModel? user;
  BuildContext? context;
  SavedExperiencesViewModel({this.user, this.context});

  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _experienceApiService = locator<ExperienceApiService>();
  final _authService = locator<AuthService>();
  bool? isTokenExist;
  List<ExperienceResults>? experienceResults = [];
  List<int>? favoriteList = [];

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future<List<int>?> getUserData() async {
    favoriteList = user!.favoriteExperiences;

    return favoriteList;
  }

  updateUserData({int? index, context}) async {
    String? token = await _tokenService.getTokenValue();
    favoriteList!.removeAt(index!);
    notifyListeners();
    setBusy(true);
    _authService.updateFavoritesUser(
      context: context,
      token: token,
      body: {
        "favorite_experiences": favoriteList,
      },
    ).then((value) {
      if (value != null) {
        experienceResults!.removeAt(index);
        notifyListeners();
        setBusy(false);
      }
    });
  }

  Future<List<ExperienceResults?>> getFavoriteExperiences() async {
    favoriteList = await getUserData();
    if (favoriteList!.isNotEmpty) {
      return await _experienceApiService
          .getPublicExperiences(
        page: 1,
      )
          .then((value) {
        if (value != null) {
          experienceResults = [];
          for (var experience in value.results!) {
            if (favoriteList!.contains(experience.id)) {
              experienceResults!.add(experience);
            }
          }
          notifyListeners();

          return experienceResults!;
        } else {
          return [];
        }
      });
    } else {
      return [];
    }
  }

  @override
  Future<List<ExperienceResults?>> futureToRun() async {
    return getFavoriteExperiences();
  }
}
