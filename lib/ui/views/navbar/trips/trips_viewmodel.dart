import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TripsViewModel extends FutureViewModel<List<ExperienceResults?>> {
  int index = 1;
  final _navigationService = locator<NavigationService>();
  final _experienceApiService = locator<ExperienceApiService>();
  bool? isTokenExist;
  ExperienceModel? experienceModels;

  void selectCategory({ind}) {
    index = ind;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future<List<ExperienceResults?>> getPublicExperiences({String? query}) async {
    experienceModels = await _experienceApiService.getPublicExperiences(query: query);
    notifyListeners();
    return experienceModels!.results!;
  }

  @override
  Future<List<ExperienceResults?>> futureToRun() async {
    return await getPublicExperiences();
  }
}