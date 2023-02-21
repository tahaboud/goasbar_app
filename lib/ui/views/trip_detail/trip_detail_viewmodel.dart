import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/shared/app_configs.dart';
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

  String formatYear(String date) => date.substring(0,4).toString();

  String formatDay(String date) => date.substring(8,10).toString();

  String formatMonthYear(String? dateTime) {
    final String year = formatYear(dateTime!);
    final String day = formatDay(dateTime);
    final String month = shortMonths[int.parse(dateTime.substring(5,7))];
    return '$day $month $year';
  }
}