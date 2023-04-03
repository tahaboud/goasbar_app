import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/public_provider_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatItemViewModel extends FutureViewModel<String?> {
  ChatItemViewModel({this.id, this.isUser});
  final int? id;
  final bool? isUser;

  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _providerApiService = locator<ProviderApiService>();
  final _tokenService = locator<TokenService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future<String?> getUserPicture({context}) async {
    String? token = await _tokenService.getTokenValue();
    return await _authService.getUserPicture(context: context, token: token, userId: id);
  }

  Future<String?> getProviderPicture({context}) async {
    PublicProviderModel? publicProviderModel = await _providerApiService.getPublicProviderInfo(providerId: id);

    return publicProviderModel!.response!.image;
  }

  @override
  Future<String?> futureToRun() async {
    return isUser! ? await getUserPicture() : await getProviderPicture();
  }
}