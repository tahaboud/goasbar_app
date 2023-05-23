import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:goasbar/shared/app_configs.dart';

class SearchViewModel extends BaseViewModel {
  SearchViewModel({this.context});
  BuildContext? context;

  int index = 1;
  final _navigationService = locator<NavigationService>();
  final _experienceApiService = locator<ExperienceApiService>();
  bool? isTokenExist;
  ExperienceModel? experienceModels;
  TextEditingController searchDate = TextEditingController();
  String? from = '', to = '';
  String? genderConstraint = genderConstraints[0];
  String? category = 'Experience Category'.tr();
  String? city = 'Search by Region'.tr();
  int pageNumber = 1;

  List<String> citiesWithNone () {
    List<String> list = [];
    list.add('Search by Region'.tr());
    list.addAll(cities);

    return list;
  }

  List<String> categoriesWithNone () {
    List<String> list = [];
    list.add('Experience Category'.tr());
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
    from = '';
    to = '';
    notifyListeners();
  }

  void showDateRangePicker(context) async {
    List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        disableYearPicker: true,
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: kMainColor1,
      ),
      initialValue: [
        DateTime.now(),
      ],

      dialogSize: const Size(325, 340),
    );

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted1 = formatter.format(picked![0]!);
    final String formatted2 = formatter.format(picked[1]!);

    from = formatted1;
    to = formatted2;
    searchDate.text = "from $from to $to";
    notifyListeners();
  }

  Future getPublicExperiencesFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      pageNumber++;
      print("index : $index");
      ExperienceModel? experienceModelsList = await _experienceApiService.getPublicExperiences(page: pageNumber, context: context);
      experienceModels!.results!.addAll(experienceModelsList!.results!);
      notifyListeners();
    }
  }

  getPublicExperiences({String? query,}) async {
    setBusy(true);
    experienceModels = null;
    experienceModels = await _experienceApiService.getPublicExperiences(query: query, page: pageNumber, context: context);
    notifyListeners();
    setBusy(false);
    return experienceModels!;
  }
}