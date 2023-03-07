import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CompleteProfileViewModel extends BaseViewModel {
  bool isObscure = true;
  TextEditingController gender = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();
  String? city = "RIYADH";

  void changeObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view,);
  }

  void back() {
    _navigationService.back();
  }

  String? validateEmail ({String? value}) {
    return _validationService.validateEmail(value);
  }

  String? validatePassword ({String? value}) {
    return _validationService.passwordValidation(value);
  }

  String? validateRePassword ({String? password, String? rePassword}) {
    return _validationService.rePasswordValidation(password: password, rePassword: rePassword);
  }

  updateCity({String? value}) {
    city = value;
    notifyListeners();
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
}