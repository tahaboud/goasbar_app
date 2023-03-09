import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/data_models/timing_response.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/timing_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:stacked/stacked.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:stacked_services/stacked_services.dart';

class TimingViewModel extends FutureViewModel<dynamic> {
  final int? experienceId;
  BuildContext? context;
  TimingViewModel({this.experienceId, this.context});

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

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
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

  String? formatSelectedDate ({DateTime? date}) {
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

  showBookingList() {
    _dialogService.showCustomDialog(
      variant: DialogType.bookingList,
    );
  }

  showNewTimingBottomSheet({String? date, TimingResponse? timing}) async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.newTiming,
      isScrollControlled: true,
      barrierDismissible: true,
      data: date,
      // ignore: deprecated_member_use
      customData: timing ?? experienceId,
    );

    if (response!.confirmed) {
      getTimingsList(experienceId: experienceId,);
    }
  }

  getTimingsList({int? experienceId,}) async {
    String? token = await _tokenService.getTokenValue();
    timingListModel = await _timingApiService.getTimingsList(context: context, token: token, experienceId: experienceId,);
    notifyListeners();
  }

  launchMaps ({double? lat, double? long}) {
    MapsLauncher.launchCoordinates(lat!, long!);
  }

  Future<bool?> deleteTiming({int? timingId, int? experienceId}) async {
    String? token = await _tokenService.getTokenValue();
    return await _timingApiService.deleteTiming(context: context, token: token, timingId: timingId).then((value) {
      getTimingsList(experienceId: experienceId,);
      return value;
    });
  }

  @override
  Future futureToRun() async {
    await getTimingsList(experienceId: experienceId,);
  }
}