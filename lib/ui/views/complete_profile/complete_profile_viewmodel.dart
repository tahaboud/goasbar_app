import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CompleteProfileViewModel extends BaseViewModel {
  bool isObscure = true;
  TextEditingController gender = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _validationService = locator<ValidationService>();

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

  validateEmail ({String? value}) {
    _validationService.validateEmail(value);
  }

  void showSelectionDialog({gen}) async {
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.selection,
      data: gen,
    );

    gender.text = response!.data;
    notifyListeners();
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
}