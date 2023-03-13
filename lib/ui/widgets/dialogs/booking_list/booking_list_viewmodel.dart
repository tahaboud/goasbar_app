import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_timing_booking.dart';
import 'package:goasbar/data_models/provider_timing_booking_response.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingListViewModel extends FutureViewModel<List<ProviderTimingBookingResults?>> {
  BookingListViewModel({this.context, this.timingId});
  final int? timingId;
  BuildContext? context;

  ProviderTimingBooking? providerTimingBooking;
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();
  final _bookingApiService = locator<BookingApiService>();

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future<List<ProviderTimingBookingResults?>> getProviderTimingBookings() async {
    String? token = await _tokenService.getTokenValue();
    providerTimingBooking = await _bookingApiService.getProviderTimingBookings(context: context, token: token, timingId: timingId,);
    notifyListeners();

    return providerTimingBooking!.results!;
  }

  @override
  Future<List<ProviderTimingBookingResults?>> futureToRun() async {
    return await getProviderTimingBookings();
  }
}