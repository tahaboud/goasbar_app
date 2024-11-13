import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/timing_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/timing_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewTimingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _dialogService = locator<DialogService>();
  final _mediaService = locator<MediaService>();
  final _tokenService = locator<TokenService>();
  final _timingApiService = locator<TimingApiService>();

  TextEditingController typeOfIdentity = TextEditingController();
  File? file;
  String? pickedTimeForRequest;
  int pageIndex = 1;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view);
  }

  void back() {
    _navigationService.back();
  }

  void changeIndex({index}) {
    pageIndex = index;
    notifyListeners();
  }

  String? validateEmail({String? value}) {
    return _validationService.validateEmail(value);
  }

  String? validatePhoneNumber({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  void showTypeOfIdentityDialog({type}) async {
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.typeOfIdentity,
      data: type,
    );

    typeOfIdentity.text = response!.data;
    notifyListeners();
  }

  void pickImage() async {
    file = await _mediaService.getImage();
    if (file != null) {
      notifyListeners();
    }
  }

  showErrorDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
    );
  }

  setToken({token}) {
    _tokenService.setTokenValue(token);
  }

  void showStartTimePicker(context, TextEditingController startTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    String hour = picked!.hour < 10 ? "0${picked.hour}" : "${picked.hour}";
    String minute =
        picked.minute < 10 ? "0${picked.minute}" : "${picked.minute}";

    startTime.text = "$hour:$minute";

    notifyListeners();
  }

  void showStartDatePicker(context, TextEditingController startDate) async {
    List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        disableModePicker: true,
        firstDate: DateTime.now(),
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: kMainColor1,
      ),
      value: [
        DateTime.now(),
      ],
      dialogSize: const Size(325, 340),
    );

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(picked![0]!);

    startDate.text = formatted;
    notifyListeners();
  }

  Future<TimingModel?> createTiming(
      {Map? body, int? experienceId, context}) async {
    String? token = await _tokenService.getTokenValue();
    return await _timingApiService.createTiming(
        context: context, token: token, body: body, experienceId: experienceId);
  }

  Future<TimingModel?> updateTiming({Map? body, int? timingId, context}) async {
    String? token = await _tokenService.getTokenValue();
    return await _timingApiService.updateTiming(
        context: context, token: token, body: body, timingId: timingId);
  }
}
