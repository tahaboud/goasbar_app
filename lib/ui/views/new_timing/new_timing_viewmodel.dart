import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/timing_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/timing_api_service.dart';
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
  final _timingApiService = locator<TimingApiService>();

  TextEditingController startDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController typeOfIdentity = TextEditingController();
  File? file;
  String? pickedTimeForRequest;
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

  void showStartTimePicker(context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    String dayPeriod = picked!.period == DayPeriod.pm ? "PM" : "AM";
    String hour = picked.hourOfPeriod < 10 ? "0${picked.hourOfPeriod}" : "${picked.hourOfPeriod}";
    String minute = picked.minute < 10 ? "0${picked.minute}" : "${picked.minute}";

    startTime.text = "$hour:$minute $dayPeriod";

    if (picked.period == DayPeriod.am) {
      pickedTimeForRequest = "$hour:$minute";
    } else {
      String hourInPm = "${picked.hourOfPeriod + 12}";
      pickedTimeForRequest = "$hourInPm:$minute";
    }

    notifyListeners();
  }

  Future<TimingModel?> createTiming ({Map? body, int? experienceId}) async {
    String token = await _tokenService.getTokenValue();
    return await _timingApiService.createTiming(token: token, body: body, experienceId: experienceId);
  }

  Future<TimingModel?> updateTiming ({Map? body, int? timingId}) async {
    String token = await _tokenService.getTokenValue();
    return await _timingApiService.updateTiming(token: token, body: body, timingId: timingId);
  }
}