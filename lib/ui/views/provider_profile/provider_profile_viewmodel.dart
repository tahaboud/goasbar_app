import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_public_experience_model.dart';
import 'package:goasbar/data_models/provider_public_experience_response.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:goasbar/services/url_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProviderProfileViewModel extends FutureViewModel<List<ProviderPublicExperienceResults?>?> {
  int? providerId;
  BuildContext? context;
  ProviderProfileViewModel({this.context, this.providerId});

  final _navigationService = locator<NavigationService>();
  final _providerApiService = locator<ProviderApiService>();
  final _urlService = locator<UrlService>();
  ProviderPublicExperienceModel? providerPublicExperience;
  int pageNumber = 1;

  dynamic navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view,);
  }

  void back() {
    _navigationService.back();
  }

  void launchEmail({String? email}) {
    _urlService.launchEmail(email: email);
  }

  void launchPhoneCall({String? phoneNumber}) {
    _urlService.launchPhoneCall(phoneNumber: phoneNumber);
  }

  void launchLink({String? link}) {
    _urlService.launchLink(link: link!);
  }

  Future getProviderPublicExperiencesFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      pageNumber++;
      print("index : $index");
      ProviderPublicExperienceModel? providerPublicExperienceList = await _providerApiService.getProviderPublicExperiences(context: context, providerId: providerId, page: pageNumber);
      providerPublicExperience!.results!.addAll(providerPublicExperienceList!.results!);
      notifyListeners();
    }
  }

  Future<List<ProviderPublicExperienceResults>?>? getProviderPublicExperiences() async {
    providerPublicExperience = await _providerApiService.getProviderPublicExperiences(context: context, providerId: providerId, page: pageNumber);
    notifyListeners();
    return providerPublicExperience!.results!;
  }

  @override
  Future<List<ProviderPublicExperienceResults?>?> futureToRun() async {
    return getProviderPublicExperiences();
  }
}