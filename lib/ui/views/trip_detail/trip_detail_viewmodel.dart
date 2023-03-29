import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/public_provider_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/url_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    String token = await _tokenService.getTokenValue();
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

  bool getIsFav () {
    favoriteList = user!.favoriteExperiences;
    isFav = favoriteList!.contains(experience!.id);
    notifyListeners();

    return isFav;
  }

  mapToMarkers(LatLng latLng) {
    customMarkers.add(Marker(
      markerId: const MarkerId("markerId"),
      position: latLng,
    ));

    notifyListeners();
  }

  setMapAndMarker() {
    if (experience!.latitude != null && experience!.longitude != null) {
      kGooglePlex = CameraPosition(
        target: LatLng(experience!.latitude, experience!.longitude),
        zoom: 13.4746,
      );

      mapToMarkers(LatLng(experience!.latitude, experience!.longitude));
    }
  }

  Future<PublicProviderModel?> getProvider () async {
    if (user != null) getIsFav();
    provider = await _providerApiService.getPublicProviderInfo(providerId: experience!.providerId);
    setMapAndMarker();
    notifyListeners();

    return provider;
  }

  @override
  Future<PublicProviderModel?> futureToRun() async {
    return getProvider();
  }
}