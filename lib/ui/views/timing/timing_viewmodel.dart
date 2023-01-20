import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TimingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  bool? isCollapsed = false;
  DateTime selectedDate = DateTime.now();
  final List<String> shortMonths = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void collapse({int? index}) {
    isCollapsed = !isCollapsed!;
    notifyListeners();
  }

  String formatYear(DateTime date) => date.year.toString();

  String formatMonthYear(DateTime? dateTime) {
    final String year = formatYear(dateTime!);
    final String month = shortMonths[dateTime.month - DateTime.january];
    return '$month $year';
  }

  void selectDate({DateTime? date}) {
    selectedDate = date!;
    notifyListeners();
  }

  showBookingList() {
    _dialogService.showCustomDialog(
      variant: DialogType.bookingList,
    );
  }

  showNewTimingBottomSheet() async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.newTiming,
      isScrollControlled: true,
      barrierDismissible: true,
    );

    if (response!.confirmed) {
      notifyListeners();
    }
  }
}