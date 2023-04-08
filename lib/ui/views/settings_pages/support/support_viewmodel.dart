import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/services/url_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SupportViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _urlService = locator<UrlService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  void launchWebSite() {
    _urlService.launchLink(link: "https://www.goasbar.com/");
  }

  void launchEmail() {
    _urlService.launchEmail(email: "contact@goasbar.com");
  }

  void launchPhoneCall() {
    _urlService.launchPhoneCall(phoneNumber: "+966 (483) -565 9898");
  }
}