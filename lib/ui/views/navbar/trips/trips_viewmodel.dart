import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/bookings_list_model.dart';
import 'package:goasbar/data_models/bookings_list_response.dart';
import 'package:goasbar/data_models/review_model_booking_history.dart';
import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TripsViewModel extends FutureViewModel<List<BookingsListResults?>?> {
  TripsViewModel({this.context});
  BuildContext? context;

  final _bookingApiService = locator<BookingApiService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _tokenService = locator<TokenService>();
  BookingsListModel? bookingsListModel;
  int pageNumber = 1;
  int index = 1;

  Future<bool?> deleteBooking({int? bookingId, context}) async {
    String? token = await _tokenService.getTokenValue();
    setBusy(true);
    return await _bookingApiService.deleteBooking(context: context, token: token, bookingId: bookingId).then((value) async {
      if (value != null && value) {
        data = await futureToRun(page: 1);
      }
      setBusy(false);
      return value;
    });
  }

  Future showReviewBottomSheet({int? bookingId, ReviewModelBookingHistory? review, user}) async {
    var response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.review,
      isScrollControlled: true,
      barrierDismissible: true,
      data: {"user": user, "review": review},
      customData: bookingId,
    );

    if (response!.confirmed) {
      data = await futureToRun(page: 1);
    } else {
      return false;
    }
  }

  void selectCategory({ind}) {
    index = ind;
    String? query;
    if (index == 1) {
      query = '';
    } else if (index == 2) {
      query = "?status=COMPLETED";
    } else if (index == 3) {
      query = "?gender=PENDING";
    }

    pageNumber = 1;
    notifyListeners();

    getUserBookings(query: query, page: pageNumber);
  }

  Future getUserBookingsFromNextPage({int? index}) async {
    if (index! % 10 == 0) {
      String? token = await _tokenService.getTokenValue();
      pageNumber++;
      print("index : $index");
      BookingsListModel? bookingResults = await _bookingApiService.getUserBookings(token: token, context: context, page: pageNumber);
      bookingsListModel!.results!.addAll(bookingResults!.results!);
      notifyListeners();
    }
  }

  Future<List<BookingsListResults?>?> getUserBookings({int? page, String? query}) async {
    String? token = await _tokenService.getTokenValue();
    bookingsListModel = await _bookingApiService.getUserBookings(token: token, context: context, page: page, query: query);
    notifyListeners();
    return bookingsListModel!.results!;
  }

  @override
  Future<List<BookingsListResults?>?> futureToRun({page}) async {
    return await getUserBookings(page: page != null ? page : pageNumber);
  }
}