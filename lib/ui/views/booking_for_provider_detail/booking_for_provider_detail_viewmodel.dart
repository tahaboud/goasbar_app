import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_public_experience_response.dart';
import 'package:goasbar/data_models/public_provider_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingForProviderDetailViewModel extends FutureViewModel<PublicProviderModel?> {
  UserModel? user;
  ProviderPublicExperienceResults? providerPublicExperience;
  BookingForProviderDetailViewModel({this.user, this.providerPublicExperience});

  bool isFav = false;
  int pageIndex = 1;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _authService = locator<AuthService>();
  final _providerApiService = locator<ProviderApiService>();
  PublicProviderModel? provider;
  List<int>? favoriteList = [];
  CameraPosition? kGooglePlex;
  Completer<GoogleMapController> controller = Completer();
  List<Marker> customMarkers = [];
  LatLng? latLon;

  void addFavorites({int? experienceId, context}) {
    isFav = !isFav;
    updateUserData(experienceId: experienceId, isRemove: isFav, context: context);
    notifyListeners();
  }

  updateUserData({int? experienceId, bool? isRemove, context}) async {
    String? token = await _tokenService.getTokenValue();
    notifyListeners();

    favoriteList = user!.favoriteExperiences;

    if (!isRemove!) {
      if (favoriteList!.contains(experienceId!)) favoriteList!.remove(experienceId);
    } else {
      if (!favoriteList!.contains(experienceId!)) favoriteList!.add(experienceId);
    }

    notifyListeners();
    _authService.updateFavoritesUser(context: context, token: token, body: {
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
    Share.share('check out this experience $link');
  }

  String formatYear(String date) => date.substring(0,4).toString();

  String formatDay(String date) => date.substring(8,10).toString();

  String formatMonthYear(String? dateTime) {
    final String year = formatYear(dateTime!);
    final String day = formatDay(dateTime);
    final String month = shortMonths[int.parse(dateTime.substring(5,7))];
    return '$day $month $year';
  }

  bool getIsFav () {
    favoriteList = user!.favoriteExperiences;
    isFav = favoriteList!.contains(providerPublicExperience!.id);
    notifyListeners();

    return isFav;
  }

  Future<PublicProviderModel?> getProvider () async {
    if (user != null) getIsFav();
    provider = await _providerApiService.getPublicProviderInfo(providerId: providerPublicExperience!.providerId);
    if (providerPublicExperience!.latitude != null && providerPublicExperience!.longitude != null) {
      kGooglePlex = CameraPosition(
        target: LatLng(providerPublicExperience!.latitude, providerPublicExperience!.longitude),
        zoom: 13.4746,
      );
    }
    notifyListeners();

    return provider;
  }

  @override
  Future<PublicProviderModel?> futureToRun() async {
    return getProvider();
  }
}