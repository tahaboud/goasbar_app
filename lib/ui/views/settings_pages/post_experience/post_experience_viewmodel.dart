import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PostExperienceViewModel extends FutureViewModel<List<ExperienceResults>> {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _experienceApiService = locator<ExperienceApiService>();
  final _tokenService = locator<TokenService>();
  List<bool?> isCollapsed = [];
  ExperienceModel? experienceModels;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void collapse({int? index}) {
    isCollapsed[index!] = !isCollapsed[index]!;
    notifyListeners();
  }

  showAddExperienceInfoBottomSheet({ExperienceResults? experience}) async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addExperience,
      isScrollControlled: true,
      barrierDismissible: true,
      data: experience,
    );

    if (response!.confirmed) {
      setBusy(true);
      isCollapsed = [];
      data = await futureToRun();
      setBusy(false);
    }
  }

  deleteIsCollapsedItem({int? index}) {
    isCollapsed.removeAt(index!);
    notifyListeners();
  }

  Future<ExperienceModel?> getProviderExperiences() async {
    String? token = await _tokenService.getTokenValue();
    return await _experienceApiService.getProviderExperiences(token: token);
  }

  Future<bool?> deleteExperience({int? experienceId}) async {
    String? token = await _tokenService.getTokenValue();
    setBusy(true);
    return await _experienceApiService.deleteExperience(token: token, experienceId: experienceId).then((value) async {
      isCollapsed = [];
      data = await futureToRun();
      setBusy(false);
      return value;
    });
  }

  @override
  Future<List<ExperienceResults>> futureToRun() async {
    experienceModels = await getProviderExperiences();
    for (var i = 0; i < experienceModels!.results!.length; i++) {
      isCollapsed.add(false);
    }
    notifyListeners();

    return experienceModels!.results!;
  }
}