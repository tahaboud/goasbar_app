import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditProfileViewModel extends FutureViewModel<dynamic> {
  bool isObscure = true;
  TextEditingController gender = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();
  final _mediaService = locator<MediaService>();
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  File? file;
  UserModel? user;

  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  String? validateEmail ({String? value}) {
    return _validationService.validateEmail(value);
  }

  String? validatePhoneNumber ({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  void showSelectionDialog({gen}) async {
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.selection,
      data: gender.text.isNotEmpty ? gender.text : gen,
    );

    gender.text = response!.data;
    notifyListeners();
  }

  void showBirthDayPicker(context) async {

    List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: DateTime.now(),
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

    birthDate.text = formatted;
    notifyListeners();
  }

  void pickImage () async {
    file = await _mediaService.getImage();
    if (file != null) {
      notifyListeners();
    }
  }

  Future<dynamic> getUserData() async {
    String token = await _tokenService.getTokenValue();
    return _authService.getUserData(token: token).then((value) {
      if (value != null) {
        user = value;
        notifyListeners();
        return user;
      } else {
        return null;
      }
    });
  }

  Future<dynamic> updateUserData({Map<String, dynamic>? body}) async {
    String token = await _tokenService.getTokenValue();
    return _authService.updateUserData(token: token, body: body,).then((value) {
      if (value != null) {
        user = value;
        notifyListeners();
        return user;
      } else {
        return null;
      }
    });
  }

  @override
  Future futureToRun() {
    return getUserData();
  }
}