import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/public_provider_model.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:goasbar/services/timing_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TripDetailViewModel extends FutureViewModel<PublicProviderModel?> {
  UserModel? user;
  ExperienceResults? experience;
  TripDetailViewModel({this.user, this.experience});

  bool isFav = false;
  int pageIndex = 1;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  final _timingApiService = locator<TimingApiService>();
  final _providerApiService = locator<ProviderApiService>();
  TimingListModel? timingListModel;
  PublicProviderModel? provider;
  List<int>? favoriteList = [];

  void addFavorites({int? experienceId}) {
    isFav = !isFav;
    updateUserData(experienceId: experienceId);
    notifyListeners();
  }

  updateUserData({int? experienceId}) async {
    String token = await _tokenService.getTokenValue();
    notifyListeners();

    favoriteList = user!.favoriteExperiences;

    favoriteList!.remove(experienceId!);
    notifyListeners();
    _authService.updateUserData(token: token, body: {
      "favorite_experiences": favoriteList,
    },);
  }

  void changeIndex({index}) {
    pageIndex = index;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  String formatYear(String date) => date.substring(0,4).toString();

  String formatDay(String date) => date.substring(8,10).toString();

  String formatMonthYear(String? dateTime) {
    final String year = formatYear(dateTime!);
    final String day = formatDay(dateTime);
    final String month = shortMonths[int.parse(dateTime.substring(5,7))];
    return '$day $month $year';
  }

  //TODO : set timings (we can have ore than one so how)
  getTimingsList({int? experienceId}) async {
    String? token = await _tokenService.getTokenValue();
    timingListModel = await _timingApiService.getTimingsList(token: token, experienceId: experienceId,);
    notifyListeners();
  }

  bool getIsFav () {
    favoriteList = user!.favoriteExperiences;
    isFav = favoriteList!.contains(experience!.id);
    notifyListeners();

    return isFav;
  }

  Future<PublicProviderModel?> getProvider () async {
    String? token = await _tokenService.getTokenValue();
    getIsFav();
    provider = await _providerApiService.getProviderInfo(token: token, providerId: experience!.providerId);
    notifyListeners();
    print(provider);

    return provider;
  }

  @override
  Future<PublicProviderModel?> futureToRun() async {
    return getProvider();
  }
}