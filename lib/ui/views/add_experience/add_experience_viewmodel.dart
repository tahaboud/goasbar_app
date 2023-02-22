import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/timing_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddExperienceInfoViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _tokenService = locator<TokenService>();
  final _experienceApiService = locator<ExperienceApiService>();
  final _timingApiService = locator<TimingApiService>();
  final _mediaService = locator<MediaService>();
  TextEditingController gender = TextEditingController();
  File? mainImage;
  List<File?>? additionalImages = [];
  int? images = 0;
  int pageIndex = 1;
  int? addedProviding = 0;
  int? addedRequirements = 0;
  String? city = "RIYADH";
  String? selectedExperienceCategory;
  String? providedGoodsText = '';
  String? requirementsText = '';
  String? pickedTimeForRequest;
  TextEditingController startDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController typeOfIdentity = TextEditingController();
  TextEditingController requirementsController1 = TextEditingController();
  TextEditingController requirementsController2 = TextEditingController();
  TextEditingController requirementsController3 = TextEditingController();
  TextEditingController requirementsController4 = TextEditingController();
  List<TextEditingController> addedRequirementsControllers = [];
  TextEditingController providedGoodsController1 = TextEditingController();
  TextEditingController providedGoodsController2 = TextEditingController();
  TextEditingController providedGoodsController3 = TextEditingController();
  TextEditingController providedGoodsController4 = TextEditingController();
  List<TextEditingController> addedProvidedGoodsControllers = [];
  String? genderConstraint = genderConstraints[0];

  updateSelectedExperienceCategory({String? category}) {
    selectedExperienceCategory = category;
    notifyListeners();
  }

  void updateProvidedGoodsText ({String? text}) {
    providedGoodsText = text;
    notifyListeners();
  }

  void updateRequirementsText ({String? text}) {
    providedGoodsText = text;
    notifyListeners();
  }

  addRequirements() {
    addedRequirements = addedRequirements! + 1;
    addedRequirementsControllers.add(TextEditingController());
    notifyListeners();
  }

  addProvidings() {
    addedProviding = addedProviding! + 1;
    addedProvidedGoodsControllers.add(TextEditingController());
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

  updateGenderConstraint({String? value}) {
    genderConstraint = value;
    notifyListeners();
  }

  void pickMainImage () async {
    mainImage = await _mediaService.getImage();
    if (mainImage != null) {
      notifyListeners();
    }
  }

  void pickImage () async {
    File? file;
    file = await _mediaService.getImage();
    if (file != null) {
      if (images! < 8) {
        images = images! + 1;
        additionalImages!.add(file);
        notifyListeners();
      }
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
    List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          disableYearPicker: true,
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

    if (picked.period == DayPeriod.am) {
      pickedTimeForRequest = "$hour:$minute";
    } else {
      String hourInPm = "${picked.hourOfPeriod + 12}";
      pickedTimeForRequest = "$hourInPm:$minute";
    }

    notifyListeners();
  }

  showNewTimingBottomSheet({String? date, int? experienceId}) async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.newTiming,
      isScrollControlled: true,
      barrierDismissible: true,
      data: date,
      // ignore: deprecated_member_use
      customData: experienceId,
    );

    if (response!.confirmed) {
      notifyListeners();
    }
  }

  Future showPublishSuccessBottomSheet() async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.publishSuccess,
      isScrollControlled: true,
      barrierDismissible: true,
    );

    if (response!.confirmed) {
      return true;
    }
  }

  Future<ExperienceResults?> createExperience({Map<String, dynamic>? body}) async {
    String? token = await _tokenService.getTokenValue();
    return await _experienceApiService.createExperience(token: token, body: body,).then((value) {
      if (value is ExperienceResults) {
        _timingApiService.createTiming(token: token, experienceId: value.id);
        return value;
      } else {
        return null;
      }
    });
  }
}