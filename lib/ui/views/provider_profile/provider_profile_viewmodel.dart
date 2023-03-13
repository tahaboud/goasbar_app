import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_public_experience_model.dart';
import 'package:goasbar/data_models/provider_public_experience_response.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProviderProfileViewModel extends FutureViewModel<List<ProviderPublicExperienceResults?>?> {
  int? providerId;
  ProviderProfileViewModel({this.providerId});

  final _navigationService = locator<NavigationService>();
  final _providerApiService = locator<ProviderApiService>();
  ProviderPublicExperienceModel? providerPublicExperience;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view,);
  }

  void back() {
    _navigationService.back();
  }

  Future<List<ProviderPublicExperienceResults>?>? getProviderPublicExperiences() async {
    providerPublicExperience = await _providerApiService.getProviderPublicExperiences(providerId: providerId);
    notifyListeners();
    return providerPublicExperience!.results!;
  }

  @override
  Future<List<ProviderPublicExperienceResults?>?> futureToRun() async {
    return getProviderPublicExperiences();
  }
}