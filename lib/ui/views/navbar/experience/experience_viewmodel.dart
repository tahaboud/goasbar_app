import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ExperienceViewModel extends FutureViewModel<List<ExperienceResults?>> {
  int index = 1;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _experienceApiService = locator<ExperienceApiService>();
  bool? isTokenExist;
  ExperienceModel? experienceModels;
  UserModel? user;

  void selectCategory({ind}) {
    index = ind;
    String? query;
    if (index == 1) {
      query = '';
    } else if (index == 2) {
      query = "gender=FAMILIES";
    } else if (index == 3) {
      query = "gender=MEN";
    } else {
      query = "gender=WOMEN";
    }

    notifyListeners();

    getPublicExperiences(query: query);
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future<List<ExperienceResults?>> getPublicExperiences({String? query}) async {
    String? token = await _tokenService.getTokenValue();
    experienceModels = await _experienceApiService.getPublicExperiences(token: token, query: query);
    notifyListeners();
    return experienceModels!.results!;
  }

  @override
  Future<List<ExperienceResults?>> futureToRun() async {
    return getPublicExperiences();
  }
}