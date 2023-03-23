import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_public_experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingItemForProviderViewModel extends FutureViewModel<bool?> {
  final UserModel? user;
  final ProviderPublicExperienceResults? experience;
  BookingItemForProviderViewModel({this.user, this.experience});

  final _navigationService = locator<NavigationService>();
  List<int>? favoriteList = [];
  bool isFav = false;

  navigateTo({view}) async {
    await _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
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