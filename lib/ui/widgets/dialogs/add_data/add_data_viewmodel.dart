import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddDataViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void showBirthDayPicker(context) async {
    List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: kMainColor1,
      ),
      value: [
        DateTime.now(),
      ],
      dialogSize: const Size(325, 340),
    );

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(picked![0]!);

    birthDate.text = formatted;
    notifyListeners();
  }

  TextEditingController gender = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  String? city = "Riyadh".tr();
  final _dialogService = locator<DialogService>();
  UserModel? user;
  bool? isClicked = false;
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();

  List<String> citiesWithNone() {
    List<String> list = [];
    list.addAll(cities);
    list.removeAt(0);

    return list;
  }

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
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

  Future<dynamic> updateUserData({Map<String, dynamic>? body, context}) async {
    updateIsClicked(value: true);

    String? token = await _tokenService.getTokenValue();
    return _authService
        .updateUserData(
      context: context,
      token: token,
      body: body,
    )
        .then((value) {
      if (value != null) {
        user = value;
        notifyListeners();
        return user;
      } else {
        return null;
      }
    });
  }
}
