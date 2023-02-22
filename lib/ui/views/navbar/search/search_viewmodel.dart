import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:goasbar/shared/app_configs.dart';

class SearchViewModel extends BaseViewModel {
  int index = 1;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _experienceApiService = locator<ExperienceApiService>();
  bool? isTokenExist;
  ExperienceModel? experienceModels;
  TextEditingController searchDate = TextEditingController();
  String? genderConstraint = genderConstraints[0];
  String? category = 'Experience Category';
  String? city = 'Search City';

  List<String> citiesWithNone () {
    List<String> list = [];
    list.add('Search City');
    list.addAll(cities);

    return list;
  }

  List<String> categoriesWithNone () {
    List<String> list = [];
    list.add('Experience Category');
    list.addAll(categories);

    return list;
  }

  void selectCategory({ind}) {
    index = ind;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  updateCity({String? value}) {
    city = value;
    notifyListeners();
  }

  updateCategory({String? value}) {
    category = value;
    notifyListeners();
  }

  updateGenderConstraint({String? value}) {
    genderConstraint = value;
    notifyListeners();
  }

  void clearSearchDate() {
    searchDate.clear();
    notifyListeners();
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

    searchDate.text = formatted;
    notifyListeners();
  }

  getPublicExperiences({String? query}) async {
    String? token = await _tokenService.getTokenValue();
    setBusy(true);
    experienceModels = null;
    experienceModels = await _experienceApiService.getPublicExperiences(token: token, query: query);
    notifyListeners();
    setBusy(false);
    return experienceModels!;
  }
}