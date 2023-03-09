import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/image_set_model.dart';
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
  AddExperienceInfoViewModel({this.experience});
  final ExperienceResults? experience;

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
  bool? isProfileImageFromLocal = false;
  bool? isHasAdditionalImagesFromLocal = false;
  List<ImageSet?>? additionalImages = [];
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

  onStart() {
    if (experience != null) {
      setBusy(true);
      city = getCity();
      genderConstraint = getGenderConstraint();
      selectedExperienceCategory = getSelectedExperienceCategory();
      if (experience!.profileImage != null) mainImage = File(experience!.profileImage!);
      if (experience!.imageSet!.isNotEmpty) {
        additionalImages = experience!.imageSet;
        images = experience!.imageSet!.length;
      }

      if (experience!.providedGoods != null) {
        for (var providedGood in experience!.providedGoods!.split('\n')) {
          if (providedGood.isNotEmpty) {
            if (providedGoodsController1.text.isEmpty) {
              providedGoodsController1.text = providedGood;
            } else if (providedGoodsController2.text.isEmpty) {
              providedGoodsController2.text = providedGood;
            } else if (providedGoodsController3.text.isEmpty) {
              providedGoodsController3.text = providedGood;
            } else if (providedGoodsController4.text.isEmpty) {
              providedGoodsController4.text = providedGood;
            } else {
              addProvidings(text: providedGood);
            }
          }
        }
      }

      if (experience!.requirements != null) {
        for (var requirement in experience!.requirements!.split('\n')) {
          if (requirement.isNotEmpty) {
            if (requirementsController1.text.isEmpty) {
              requirementsController1.text = requirement;
            } else if (requirementsController2.text.isEmpty) {
              requirementsController2.text = requirement;
            } else if (requirementsController3.text.isEmpty) {
              requirementsController3.text = requirement;
            } else if (requirementsController4.text.isEmpty) {
              requirementsController4.text = requirement;
            } else {
              addRequirements(text: requirement);
            }
          }
        }
      }

      notifyListeners();
      setBusy(false);
    }
  }

  String? getCity() {
    city = experience != null ? experience!.city : null;
    return city;
  }

  updateCity({String? value}) {
    city = value;
    notifyListeners();
  }

  String? getGenderConstraint () {
    genderConstraint = experience != null ? experience!.gender == "None" ? "No constrains"
      : experience!.gender == "FAMILIES" ? "Families" : experience!.gender == "MEN" ? "Men Only"
      : "Women Only" : genderConstraints[0];
    return genderConstraint;
  }

  updateGenderConstraint({String? value}) {
    genderConstraint = value;
    notifyListeners();
  }

  updateSelectedExperienceCategory({String? category}) {
    if (selectedExperienceCategory == category) {
      selectedExperienceCategory = null;
    } else {
      selectedExperienceCategory = category;
    }
    notifyListeners();
  }

  String? getSelectedExperienceCategory() {
    selectedExperienceCategory = experience != null ? experience!.categories!.isNotEmpty
        ? experience!.categories![0] : null : null;

    return selectedExperienceCategory;
  }

  void updateProvidedGoodsText ({String? text}) {
    providedGoodsText = text;
    notifyListeners();
  }

  void updateRequirementsText ({String? text}) {
    requirementsText = text;
    notifyListeners();
  }

  addRequirements({text}) {
    addedRequirements = addedRequirements! + 1;
    addedRequirementsControllers.add(TextEditingController(text: text));
    notifyListeners();
  }

  addProvidings({text}) {
    addedProviding = addedProviding! + 1;
    addedProvidedGoodsControllers.add(TextEditingController(text: text));
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

  void pickMainImage () async {
    mainImage = await _mediaService.getImage();
    if (mainImage != null) {
      isProfileImageFromLocal = true;
      notifyListeners();
    }
  }

  void pickImage () async {
    File? file;
    file = await _mediaService.getImage();
    if (file != null) {
      if (images! < 8) {
        images = images! + 1;
        isHasAdditionalImagesFromLocal = true;
        additionalImages!.add(ImageSet(image: file.path));
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
      if (picked.hourOfPeriod == 12) {
        pickedTimeForRequest = "00:$minute";
      } else {
        String hourInPm = "${picked.hourOfPeriod + 12}";
        pickedTimeForRequest = "$hourInPm:$minute";
      }
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

  Future<ExperienceResults?> createExperience({context, Map<String, dynamic>? body, Map<String, dynamic>? timingBody,}) async {
    String? token = await _tokenService.getTokenValue();
    return await _experienceApiService.createExperience(token: token, body: body, context: context!).then((value) {
      if (value is ExperienceResults) {
        _timingApiService.createTiming(context: context, token: token, experienceId: value.id, body: timingBody);
        return value;
      } else {
        return null;
      }
    });
  }

  Future<ExperienceResults?> updateExperience({bool? hasImages, Map<String, dynamic>? body, context, int? experienceId}) async {
    String? token = await _tokenService.getTokenValue();
    return await _experienceApiService.updateExperience(context: context, hasImages: hasImages, token: token, body: body, experienceId: experienceId).then((value) {
      if (value is ExperienceResults) {
        return value;
      } else {
        return null;
      }
    });
  }

  Future<bool?> deleteExperienceImage({ImageSet? image, context}) async {
    String? token = await _tokenService.getTokenValue();
    setBusy(true);
    return await _experienceApiService.deleteExperienceImage(token: token, imageId: image!.id, context: context,).then((value) async {
      additionalImages!.remove(image);
      images = images! - 1;
      notifyListeners();
      setBusy(false);
      return value;
    });
  }
}