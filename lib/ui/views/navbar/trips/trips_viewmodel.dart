import 'dart:async';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:stacked/stacked.dart';

class TripsViewModel extends FutureViewModel<List<ExperienceResults?>> {
  final _experienceApiService = locator<ExperienceApiService>();
  ExperienceModel? experienceModels;
  int pageNumber = 1;

  Future getPublicExperiencesFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      pageNumber++;
      print("index : $index");
      ExperienceModel? experienceModelsList = await _experienceApiService.getPublicExperiences(page: pageNumber);
      experienceModels!.results!.addAll(experienceModelsList!.results!);
      notifyListeners();
    }
  }

  Future<List<ExperienceResults?>> getPublicExperiences({String? query,}) async {
    experienceModels = await _experienceApiService.getPublicExperiences(query: query, page: pageNumber);
    notifyListeners();
    return experienceModels!.results!;
  }

  @override
  Future<List<ExperienceResults?>> futureToRun() async {
    return await getPublicExperiences();
  }
}