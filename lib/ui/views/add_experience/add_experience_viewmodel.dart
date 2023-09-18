import 'dart:async';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:geocoding/geocoding.dart';

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
  String? city = "Riyadh".tr();
  List<dynamic>? selectedExperienceCategory = [];
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
  bool? isClicked = false;
  CameraPosition? kGooglePlex;
  Completer<GoogleMapController> controller = Completer();
  List<Marker> customMarkers = [];
  LatLng? latLon;
  Placemark? address;

  Future getAddressFromCoordinates({LatLng? latLng})async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng!.latitude, latLng.longitude);
    address = placemarks[0];

    notifyListeners();
  }

  launchMaps ({LatLng? latLon}) {
    MapsLauncher.launchCoordinates(latLon!.latitude, latLon.longitude);
  }

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  getTappedPosition(LatLng latLong) async {
    final CameraPosition position = CameraPosition(
      target: latLong,
      zoom: 16.151926040649414,
    );

    mapToMarkers(latLong);
    latLon = latLong;

    getAddressFromCoordinates(latLng: latLon);

    final GoogleMapController ctr = await controller.future;
    ctr.animateCamera(CameraUpdate.newCameraPosition(position));

    notifyListeners();
  }

  mapToMarkers(LatLng latLng) {
    customMarkers.add(Marker(
      markerId: const MarkerId("markerId"),
      position: latLng,
    ));

    notifyListeners();
  }

  onStart() {
    if (experience != null) {
      setBusy(true);
      if (experience!.latitude != null && experience!.longitude != null) latLon = LatLng(experience!.latitude, experience!.longitude);
      if (experience!.latitude != null && experience!.longitude != null) {
        kGooglePlex = CameraPosition(
          target: LatLng(experience!.latitude, experience!.longitude),
          zoom: 13.4746,
        );
        mapToMarkers(LatLng(experience!.latitude, experience!.longitude));
        getAddressFromCoordinates(latLng: LatLng(experience!.latitude, experience!.longitude));
      } else {
        kGooglePlex = const CameraPosition(
          target: LatLng(24.720495, 46.675468),
          zoom: 13.4746,
        );
      }
      city = getCity();
      genderConstraint = getGenderConstraint();
      selectedExperienceCategory = getSelectedExperienceCategory();
      if (experience!.profileImage != null) mainImage = File(experience!.profileImage!);
      if (experience!.imageSet!.isNotEmpty) {
        additionalImages = experience!.imageSet;
        images = experience!.imageSet!.length;
      }

      if (experience!.providedGoods != null) {
        for (var providedGood in experience!.providedGoods!.split(';')) {
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
        for (var requirement in experience!.requirements!.split(';')) {
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
    } else {
      setBusy(true);
      city = getCity();
      kGooglePlex = const CameraPosition(
        target: LatLng(24.720495, 46.675468),
        zoom: 13.4746,
      );
      setBusy(false);
      notifyListeners();
    }
  }

  String? getCity() {
    city = experience != null ? "${experience!.city![0]}${experience!.city!.substring(1).replaceAll('_', ' ').toLowerCase()}" : null;
    return city;
  }

  updateCity({String? value}) {
    city = value;
    notifyListeners();
  }

  String? getGenderConstraint () {
    genderConstraint = experience != null ? experience!.gender == "None" ? "No constrains".tr()
      : experience!.gender == "FAMILIES" ? "Families only".tr() : experience!.gender == "MEN" ? "Men Only".tr()
      : "Women Only".tr() : genderConstraints[0];
    return genderConstraint;
  }

  updateGenderConstraint({String? value}) {
    genderConstraint = value;
    notifyListeners();
  }

  updateSelectedExperienceCategory({String? category}) {
    if (selectedExperienceCategory!.contains(category)) {
      selectedExperienceCategory!.remove(category);
    } else {
      selectedExperienceCategory!.add(category);
    }
    notifyListeners();
  }

  List<dynamic>? getSelectedExperienceCategory() {
    selectedExperienceCategory = experience != null ? experience!.categories!.isNotEmpty
        ? experience!.categories! : [] : [];

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
    updateIsClicked(value: true);
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
    updateIsClicked(value: true);
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