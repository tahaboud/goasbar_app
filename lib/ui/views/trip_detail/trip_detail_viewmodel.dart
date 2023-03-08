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
import 'package:goasbar/services/url_service.dart';
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
  final _urlService = locator<UrlService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  final _timingApiService = locator<TimingApiService>();
  final _providerApiService = locator<ProviderApiService>();
  TimingListModel? timingListModel;
  PublicProviderModel? provider;
  List<int>? favoriteList = [];

  void addFavorites({int? experienceId}) {
    isFav = !isFav;
    updateUserData(experienceId: experienceId, isRemove: isFav);
    notifyListeners();
  }

  updateUserData({int? experienceId, bool? isRemove}) async {
    String token = await _tokenService.getTokenValue();
    notifyListeners();

    favoriteList = user!.favoriteExperiences;

    if (!isRemove!) {
      if (favoriteList!.contains(experienceId!)) favoriteList!.remove(experienceId);
    } else {
      if (!favoriteList!.contains(experienceId!)) favoriteList!.add(experienceId);
    }

    notifyListeners();
    _authService.updateFavoritesUser(token: token, body: {
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

  share({String? link}) {
    _urlService.launchLink(link: link);
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
    if (user != null) getIsFav();
    provider = await _providerApiService.getPublicProviderInfo(providerId: experience!.providerId);
    notifyListeners();

    return provider;
  }

  @override
  Future<PublicProviderModel?> futureToRun() async {
    return getProvider();
  }
}