import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/data_models/timing_response.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/timing_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TimingViewModel extends FutureViewModel<dynamic> {
  final ExperienceResults? experience;
  BuildContext? context;
  TimingViewModel({this.experience, this.context});

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _tokenService = locator<TokenService>();
  final _timingApiService = locator<TimingApiService>();
  TimingListModel? timingListModel;
  bool? isCollapsed = false;
  DateTime selectedDate = DateTime.now();
  DateTime selectedFormattedMonthYearDate = DateTime.now();
  String? selectedFormattedDate;
  int pageNumber = 1;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void collapse({int? index}) {
    isCollapsed = !isCollapsed!;
    notifyListeners();
  }

  String formatYear(DateTime date) => date.year.toString();

  String formatMonthYear(DateTime? dateTime) {
    final String year = formatYear(dateTime!);
    final String month = shortMonths[dateTime.month - DateTime.january];
    return '$month $year';
  }

  selectFormatMonthYear({DateTime? date}) {
    selectedFormattedMonthYearDate = date!;
    notifyListeners();
  }

  String? formatSelectedDate({DateTime? date}) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date!);
    selectedFormattedDate = formatted;
    return selectedFormattedDate;
  }

  void selectDate({DateTime? date}) {
    formatSelectedDate(date: date);
    selectedDate = date!;
    notifyListeners();
  }

  showBookingList({int? timingId}) {
    _dialogService.showCustomDialog(
      variant: DialogType.bookingList,
      data: timingId,
      customData: experience,
    );
  }

  showNewTimingBottomSheet({String? date, TimingResponse? timing}) async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.newTiming,
      isScrollControlled: true,
      barrierDismissible: true,
      data: date,
      // ignore: deprecated_member_use
      customData: timing != null
          ? {"timing": timing, "experience": experience!}
          : experience!,
    );

    if (response!.confirmed) {
      getTimingsList();
    }
  }

  Future getTimingsListFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      String? token = await _tokenService.getTokenValue();
      pageNumber++;
      TimingListModel? timingList = await _timingApiService.getTimingsList(
          context: context,
          token: token,
          experienceId: experience!.id,
          page: pageNumber);
      timingListModel!.results!.addAll(timingList!.results!);
      notifyListeners();
    }
  }

  getTimingsList() async {
    String? token = await _tokenService.getTokenValue();
    timingListModel = await _timingApiService.getTimingsList(
        context: context,
        token: token,
        experienceId: experience!.id,
        page: pageNumber);
    notifyListeners();
  }

  launchMaps({double? lat, double? long}) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(lat!, long!),
      title: "Meeting point",
    );
  }

  Future<bool?> deleteTiming({int? timingId, int? experienceId}) async {
    String? token = await _tokenService.getTokenValue();
    return await _timingApiService
        .deleteTiming(context: context, token: token, timingId: timingId)
        .then((value) {
      if (value != null && value) {
        getTimingsList();
      }
      return value;
    });
  }

  @override
  Future futureToRun() async {
    await getTimingsList();
  }
}
