import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ConfirmBookingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();
  int? selectedIndexDate;
  int? selectedIndexTime;
  int? numberOfGuests = 0;
  TextEditingController birthDate = TextEditingController();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void changeSelectionDate({int? index}) {
    if (selectedIndexDate == index) {
      selectedIndexDate = null;
    } else {
      selectedIndexDate = index;
    }
    notifyListeners();
  }

  void changeSelectionTime({int? index}) {
    if (selectedIndexTime == index) {
      selectedIndexTime = null;
    } else {
      selectedIndexTime = index;
    }
    notifyListeners();
  }

  void incDecrease({int? value}) {
    if (numberOfGuests! > 0 || value! > 0) {
      numberOfGuests = numberOfGuests! + value!;
    }
    notifyListeners();
  }

  void showAvailablePlacesDialog({gen}) {
    _dialogService.showCustomDialog(
      variant: DialogType.availablePlaces,
    );
  }

  void showBirthDayPicker(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    final DateFormat formatter = DateFormat('dd . MM yyyy');
    final String formatted = formatter.format(picked!);

    birthDate.text = formatted;
    notifyListeners();
  }

  String? validatePhoneNumber ({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  void showAvailableTimingsPicker({context}) {
    showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: kMainColor1,
      ),
      dialogSize: const Size(325, 350),
    );
  }
}