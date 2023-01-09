import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SavedExperienceCardViewModel extends BaseViewModel {
  bool isFav = false;
  final _navigationService = locator<NavigationService>();

  void addFavorites() {
    isFav = !isFav;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }
}