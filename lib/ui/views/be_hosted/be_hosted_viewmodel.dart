import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_model.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/services/media_service.dart';
import 'package:goasbar/services/provider_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BeHostedInfoViewModel extends FutureViewModel<ProviderModel?> {
  BeHostedInfoViewModel({this.context});
  BuildContext? context;

  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _dialogService = locator<DialogService>();
  final _mediaService = locator<MediaService>();
  final _providerApiService = locator<ProviderApiService>();
  final _tokenService = locator<TokenService>();
  TextEditingController typeOfIdentity = TextEditingController();
  File? file;
  int pageIndex = 1;
  ProviderModel? provider;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view);
  }

  void back() {
    _navigationService.back();
  }

  void changeIndex({index}) {
    pageIndex = index;
    notifyListeners();
  }


  String? validateEmail ({String? value}) {
    return _validationService.validateEmail(value);
  }

  String? validatePhoneNumber ({String? value}) {
    return _validationService.validatePhoneNumber(value);
  }

  void showTypeOfIdentityDialog({type}) async{
    var response = await _dialogService.showCustomDialog(
      variant: DialogType.typeOfIdentity,
      data: type,
    );

    typeOfIdentity.text = response!.data;
    notifyListeners();
  }

  void pickImage () async {
    file = await _mediaService.getImage();
    if (file != null) {
      notifyListeners();
    }
  }

  showErrorDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
    );
  }

  String? writeIbanFormat({iban}) {
    String? temp = "";
    var lastI = 0;
    var i = 0;
    for (i = 0; i < iban.length;i++) {
      if (i % 5 == 0 && i != 0) {
        if (temp!.isEmpty) {
          temp = iban.substring(lastI, i);
          lastI = i;
        } else {
          temp = "$temp  ${iban.substring(lastI, i)}";
          lastI = i;
        }
      }
    }
    temp = "$temp  ${iban.substring(lastI, i)}";

    return temp;
  }

  Future<ProviderModel?> beHostedProvider({Map? body, context}) async {
    String? token = await _tokenService.getTokenValue();
    provider = await _providerApiService.createProvider(context: context, token: token, body: body,);

    return provider;
  }

  Future<ProviderModel?> updateProvider({Map? body}) async {
    String? token = await _tokenService.getTokenValue();
    provider = await _providerApiService.updateProvider(context: context, token: token, body: body,);

    return provider;
  }

  @override
  Future<ProviderModel?> futureToRun() async {
    String? token = await _tokenService.getTokenValue();
    provider = await _providerApiService.getProviderUserInfo(context: context, token: token);
    if (provider == null) {
      return null;
    }
    return provider;
  }
}