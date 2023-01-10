import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TripDetailViewModel extends BaseViewModel {
  bool isFav = false;
  int pageIndex = 1;
  final _navigationService = locator<NavigationService>();

  void addFavorites() {
    isFav = !isFav;
    notifyListeners();
  }

  void changeIndex({index}) {
    pageIndex = index;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }
}