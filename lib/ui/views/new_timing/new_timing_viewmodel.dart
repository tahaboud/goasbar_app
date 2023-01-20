import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NewTimingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _dialogService = locator<DialogService>();
  final _mediaService = locator<MediaService>();
  final _tokenService = locator<TokenService>();

  TextEditingController startDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController typeOfIdentity = TextEditingController();
  File? file;
  int pageIndex = 1;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
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


  String? validateEmail ({String? value}) {
    return _validationService.validateEmail(value);
  }

  String? validatePhoneNumber ({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  void showTypeOfIdentityDialog({type}) async{
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.typeOfIdentity,
      data: type,
    );

    typeOfIdentity.text = response!.data;
    notifyListeners();
  }

  void pickImage () async {
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

  setToken ({token}) {
    _tokenService.setTokenValue(token);
  }

  void showStartDatePicker(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    final DateFormat formatter = DateFormat('dd . MM yyyy');
    final String formatted = formatter.format(picked!);

    startDate.text = formatted;
    notifyListeners();
  }

  void showStartTimePicker(context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    String dayPeriod = picked!.period == DayPeriod.pm ? "PM" : "AM";
    startTime.text = "${picked.hourOfPeriod}:${picked.minute} $dayPeriod";
    notifyListeners();
  }
}