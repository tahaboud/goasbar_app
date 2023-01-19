import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddExperienceInfoViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _mediaService = locator<MediaService>();
  TextEditingController genderConstraints = TextEditingController();
  TextEditingController gender = TextEditingController();
  File? file;
  int? images = 0;
  int pageIndex = 1;
  String? city;
  TextEditingController startDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController typeOfIdentity = TextEditingController();

  List<Widget> providings = [
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
  ];

  List<Widget> requirements = [
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
    verticalSpaceSmall,
    const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ),
  ];

  addRequirements() {
    requirements.add(verticalSpaceSmall);
    requirements.add(const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ));

    notifyListeners();
  }

  addProvidings() {
    providings.add(verticalSpaceSmall);
    providings.add(const TextField(
      decoration: InputDecoration(
        hintText: "Providing's add-ons",
        hintStyle: TextStyle(fontSize: 14),
      ),
    ));

    notifyListeners();
  }

  updateCity({String? value}) {
    city = value;
    notifyListeners();
  }

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

  void showGenderConstraintsDialog({data}) async{
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.genderConstraints,
      data: genderConstraints.text.isNotEmpty ? genderConstraints.text : data,
    );

    genderConstraints.text = response!.data;
    notifyListeners();
  }

  void pickImage () async {
    file = await _mediaService.getImage();
    if (file != null) {
      images = images! + 1;
      notifyListeners();
    }
  }

  void showSelectionDialog({gen}) async {
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.selection,
      data: gender.text.isNotEmpty ? gender.text : gen,
    );

    gender.text = response!.data;
    notifyListeners();
  }

  showErrorDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
    );
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
    String hour = picked.hourOfPeriod < 10 ? "0${picked.hourOfPeriod}" : "${picked.hourOfPeriod}";
    String minute = picked.minute < 10 ? "0${picked.minute}" : "${picked.minute}";

    startTime.text = "$hour:$minute $dayPeriod";
    notifyListeners();
  }

  showNewTimingBottomSheet() async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.newTiming,
      isScrollControlled: true,
      barrierDismissible: true,
    );

    if (response!.confirmed) {
      notifyListeners();
    }
  }

  showPublishSuccessBottomSheet() async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.publishSuccess,
      isScrollControlled: true,
      barrierDismissible: true,
    );

    if (response!.confirmed) {
      notifyListeners();
    }
  }
}