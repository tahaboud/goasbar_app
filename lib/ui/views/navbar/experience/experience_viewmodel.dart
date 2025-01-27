import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/experience_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ExperienceViewModel extends FutureViewModel<List<ExperienceResults?>?> {
  BuildContext? context;
  bool? isUser;
  UserModel? user;
  WebSocketChannel? channel;
  int unreadMessagesCount = 0;
  ExperienceViewModel({this.context, this.isUser, this.user});

  int index = 1;
  final _navigationService = locator<NavigationService>();
  final _experienceApiService = locator<ExperienceApiService>();
  final _tokenService = locator<TokenService>();
  bool? isTokenExist;
  ExperienceModel? experienceModels;
  int pageNumber = 1;

  void selectCategory({ind}) {
    index = ind;
    String? query;
    if (index == 1) {
      query = '';
    } else if (index == 2) {
      query = "?gender=FAMILIES";
    } else if (index == 3) {
      query = "?gender=MEN";
    } else {
      query = "?gender=WOMEN";
    }

    pageNumber = 1;
    notifyListeners();

    getPublicExperiences(query: query, page: pageNumber);
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future getPublicExperiencesFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      pageNumber++;
      ExperienceModel? experienceModelsList =
          await _experienceApiService.getPublicExperiences(page: pageNumber);
      experienceModels!.results!.addAll(experienceModelsList!.results!);
      notifyListeners();
    }
  }

  Future<List<ExperienceResults?>?> getPublicExperiences(
      {String? query, int? page}) async {
    experienceModels = await _experienceApiService.getPublicExperiences(
      query: query,
      page: page,
    );
    notifyListeners();
    return experienceModels!.results ?? [];
  }

  Future connectToMainWebSocket() async {
    if (isUser == true) {
      String? token = await _tokenService.getTokenValue();
      channel = IOWebSocketChannel.connect(
          Uri.parse("$baseWebSocketUrl/ws/main/?token=$token"),
          headers: {"origin": "wss://testing.goasbar.com"});
      await channel!.ready;
      channel!.stream.listen((event) {
        unreadMessagesCount = jsonDecode(event)["count"];
        notifyListeners();
      });
    }
  }

  @override
  Future<List<ExperienceResults?>?> futureToRun() async {
    await connectToMainWebSocket();
    return await getPublicExperiences(page: pageNumber);
  }

  @override
  void dispose() {
    if (channel != null) {
      channel!.sink.close();
    }
    super.dispose();
  }
}
