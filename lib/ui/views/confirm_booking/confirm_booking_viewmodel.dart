import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ConfirmBookingViewModel extends FutureViewModel<TimingListModel?> {
  final int? experienceId;
  ConfirmBookingViewModel({this.experienceId});

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();
  final _experienceApiService = locator<ExperienceApiService>();
  TimingListModel? timingListModel;
  int? selectedIndex;
  int? numberOfGuests = 0;
  List<TextEditingController> birthDates = [];
  List<TextEditingController> phones = [];
  List<TextEditingController> names = [];

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void changeSelection({int? index}) {
    if (selectedIndex == index) {
      selectedIndex = null;
    } else {
      selectedIndex = index;
    }
    notifyListeners();
  }

  void incDecrease({int? value}) {
    if (numberOfGuests! > 0 || value! > 0) {
      numberOfGuests = numberOfGuests! + value!;

      if (value == 1) {
        names.add(TextEditingController());
        birthDates.add(TextEditingController());
        phones.add(TextEditingController());
      } else {
        names.removeLast();
        birthDates.removeLast();
        phones.removeLast();
      }
    }

    notifyListeners();
  }

  void showAvailablePlacesDialog({gen}) {
    _dialogService.showCustomDialog(
      variant: DialogType.availablePlaces,
    );
  }

  void showBirthDayPicker(context, index) async {
    List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        disableYearPicker: true,
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: kMainColor1,
      ),
      initialValue: [
        DateTime.now(),
      ],

      dialogSize: const Size(325, 340),
    );

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(picked![0]!);

    birthDates[index].text = formatted;
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

  int formatDay(String date) => int.parse(date.substring(8,10).toString());

  int formatMonth(String date) => int.parse(date.substring(5,7).toString());

  int formatYear(String date) => int.parse(date.substring(0,4).toString());

  formatDate(String? formattedDate) {
    final int year = formatYear(formattedDate!);
    final int day = formatDay(formattedDate);
    final int month = formatMonth(formattedDate);
    DateTime dateTime = DateTime(year, month, day);

    int date = dateTime.weekday;
    return weekDays[date];
  }



  Future<TimingListModel?> getExperiencePublicTimings({int? experienceId}) async {
    timingListModel = await _experienceApiService.getExperiencePublicTimings(experienceId: experienceId,);
    notifyListeners();

    return timingListModel;
  }

  @override
  Future<TimingListModel?> futureToRun() async {
    return await getExperiencePublicTimings(experienceId: experienceId);
  }
}