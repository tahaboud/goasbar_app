import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/review_model.dart';
import 'package:goasbar/services/review_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ReviewViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _reviewApiService = locator<ReviewApiService>();
  double? rating = 0;
  bool? isClicked = false;

  updateIsClicked({value}) {
    isClicked = value;
    notifyListeners();
  }

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void clearAndNavigateTo({view}) {
    _navigationService.clearStackAndShowView(view);
  }

  void back() {
    _navigationService.back();
  }

  updateRating({double? value}) {
    rating = value;
    notifyListeners();
  }

  Future<ReviewModel?> createReview({context, Map? body, int? bookingId}) async {
    updateIsClicked(value: true);
    String? token = await _tokenService.getTokenValue();
    return await _reviewApiService.createReview(token: token, body: body, bookingId: bookingId, context: context!);
  }
}