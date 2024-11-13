import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_timing_booking.dart';
import 'package:goasbar/data_models/provider_timing_booking_response.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';

class BookingListDialogViewModel
    extends FutureViewModel<List<ProviderTimingBookingResults?>> {
  BookingListDialogViewModel({this.context, this.timingId});
  final int? timingId;
  BuildContext? context;

  ProviderTimingBooking? providerTimingBooking;
  final _tokenService = locator<TokenService>();
  final _bookingApiService = locator<BookingApiService>();
  int pageNumber = 1;

  Future getProviderTimingBookingsFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      pageNumber++;
      String? token = await _tokenService.getTokenValue();
      ProviderTimingBooking? providerTimingList =
          await _bookingApiService.getProviderTimingBookings(
              context: context,
              token: token,
              timingId: timingId,
              page: pageNumber);
      providerTimingBooking!.results!.addAll(providerTimingList!.results!);
      notifyListeners();
    }
  }

  Future<List<ProviderTimingBookingResults?>>
      getProviderTimingBookings() async {
    String? token = await _tokenService.getTokenValue();
    providerTimingBooking = await _bookingApiService.getProviderTimingBookings(
        context: context, token: token, timingId: timingId, page: pageNumber);
    notifyListeners();
    return providerTimingBooking!.results!;
  }

  @override
  Future<List<ProviderTimingBookingResults?>> futureToRun() async {
    return await getProviderTimingBookings();
  }
}
