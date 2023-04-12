import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/token_service.dart';
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
  BookingModel? booking;
  int? selectedIndex;
  bool? isClicked = false;
  String? filterDate1 = "1900-01-01";
  String? filterDate2 = "3000-12-30";
  final _tokenService = locator<TokenService>();
  final _bookingApiService = locator<BookingApiService>();
  int? numberOfGuests = 0;
  List<TextEditingController> age = [];
  List<TextEditingController> phones = [];
  List<TextEditingController> firstNames = [];
  List<TextEditingController> lastNames = [];
  List<TextEditingController> genders = [];
  int pageNumber = 1;

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  Map<String, dynamic> affiliateSetToJson({firstName, lastName, age, gender, phone}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['age'] = age;
    data['gender'] = gender;
    data['phone_number'] = phone;

    return data;
  }

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
        firstNames.add(TextEditingController());
        lastNames.add(TextEditingController());
        genders.add(TextEditingController());
        age.add(TextEditingController());
        phones.add(TextEditingController());
      } else {
        firstNames.removeLast();
        lastNames.removeLast();
        genders.removeLast();
        age.removeLast();
        phones.removeLast();
      }
    }

    notifyListeners();
  }

  void showAvailablePlacesDialog({timingResponse}) {
    _dialogService.showCustomDialog(
      variant: DialogType.availablePlaces,
      data: timingResponse,
    );
  }

  String? validatePhoneNumber ({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  String? validateIsNumeric ({String? value}) {
    return _validationService.validateIsNumeric(value);
  }

  void showSelectionDialog({gender, int? index}) async {
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.selection,
      data: genders[index!].text.isNotEmpty ? genders[index].text : gender,
    );

    genders[index].text = response!.data;
    notifyListeners();
  }

  void showAvailableTimingsPicker({context}) async {
    List<DateTime?>? pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: kMainColor1,
      ),
      dialogSize: const Size(325, 350),
    );

    if (pickedDates!.length > 1) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedFilter1 = formatter.format(pickedDates[0]!);
      final String formattedFilter2 = formatter.format(pickedDates[1]!);

      filterDate1 = formattedFilter1;
      filterDate2 = formattedFilter2;

      notifyListeners();
    } else {
      filterDate1 = "1900-01-01";
      filterDate2 = "3000-12-30";

      notifyListeners();
    }
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

  Future<BookingModel?> createBooking({int? timingId, Map<String, dynamic>? body, context}) async {
    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    booking = await _bookingApiService.createBooking(context: context, token: token, timingId: timingId, body: body);

    return booking;
  }

  Future getExperiencePublicTimingsFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      pageNumber++;
      print("index : $index");
      TimingListModel? timingList = await _experienceApiService.getExperiencePublicTimings(experienceId: experienceId, page: pageNumber);
      timingListModel!.results!.addAll(timingList!.results!);
      notifyListeners();
    }
  }

  Future<TimingListModel?> getExperiencePublicTimings() async {
    timingListModel = await _experienceApiService.getExperiencePublicTimings(experienceId: experienceId, page: pageNumber);
    notifyListeners();

    return timingListModel;
  }

  @override
  Future<TimingListModel?> futureToRun() async {
    return await getExperiencePublicTimings();
  }
}