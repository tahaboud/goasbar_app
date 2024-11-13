import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/auth_response.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CompleteProfileViewModel extends BaseViewModel {
  bool isObscure = true;
  TextEditingController gender = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  String? city = "Select your city".tr();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();
  File? file;
  bool? hasImage = false;
  final _mediaService = locator<MediaService>();
  final _authService = locator<AuthService>();
  bool? isClicked = false;
  bool isValid = false;
  AuthResponse? authResponse;

  Future<File?> pickImage() async {
    file = await _mediaService.getImage();
    return file;
  }

  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(
      view,
    );
  }

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  void back() {
    _navigationService.back();
  }

  String? validateFirstName({String? value}) {
    return _validationService.validateFirstName(value);
  }

  String? validateLastName({String? value}) {
    return _validationService.validateLastName(value);
  }

  String? validateEmail({String? value}) {
    return _validationService.validateEmail(value);
  }

  String? validatePassword({String? value}) {
    return _validationService.passwordValidation(value);
  }

  String? validateRePassword({String? password, String? rePassword}) {
    return _validationService.rePasswordValidation(
        password: password, rePassword: rePassword);
  }

  String? validatePhoneNumber({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  updateCity({String? value}) {
    city = value;
    notifyListeners();
  }

  Future<String> verifyPhoneNumber({String? phoneNumber, context}) async {
    updateIsClicked(value: true);
    return await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber, context: context);
  }

  Future<String> showSelectionDialog({gen}) async {
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.selection,
      data: gender.text.isNotEmpty ? gender.text : gen,
      barrierDismissible: true,
    );

    return response != null ? response.data : "";
  }

  Future<String> showBirthDayPicker(context) async {
    List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.single,
          selectedDayHighlightColor: kMainColor1,
          lastDate: DateTime.now()),
      value: [
        DateTime.now(),
      ],
      dialogSize: const Size(325, 340),
    );

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = "";
    if (picked != null) {
      formatted = formatter.format(picked[0]!);
    }

    return formatted;
  }

  Future<String> register({Map<String, dynamic>? body, bool? hasImage}) async {
    return await _authService
        .register(
      hasImage: hasImage,
      body: body,
    )
        .then((response) {
      if (response == "success") {
        notifyListeners();
      }
      return response;
    }).catchError((error) {});
  }
}
