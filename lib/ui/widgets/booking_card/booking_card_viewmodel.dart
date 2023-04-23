import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingItemViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  List<int>? favoriteList = [];

  navigateTo({view}) async {
    await _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  int formatDay(String date) => int.parse(date.substring(8,10).toString());
  int formatDayFromToday() => DateTime.now().day;

  int formatMonth(String date) => int.parse(date.substring(5,7).toString());
  int formatMonthFromToday() => DateTime.now().month;

  int formatYear(String date) => int.parse(date.substring(0,4).toString());
  int formatYearFromToday() => DateTime.now().year;
}