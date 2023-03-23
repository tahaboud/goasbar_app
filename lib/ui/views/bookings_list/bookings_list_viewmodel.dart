import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/bookings_list_model.dart';
import 'package:goasbar/data_models/bookings_list_response.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BookingsListViewModel extends FutureViewModel<List<BookingsListResults?>?> {
  BuildContext? context;
  BookingsListViewModel({this.context});

  int index = 1;
  final _navigationService = locator<NavigationService>();
  final _bookingApiService = locator<BookingApiService>();
  final _tokenService = locator<TokenService>();
  bool? isTokenExist;
  BookingsListModel? bookingsListModel;
  int pageNumber = 1;

  void navigateTo({view}) {
    _navigationService.navigateWithTransition(view, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void back() {
    _navigationService.back();
  }

  Future<bool?> deleteBooking({int? bookingId, context}) async {
    String? token = await _tokenService.getTokenValue();
    setBusy(true);
    return await _bookingApiService.deleteBooking(context: context, token: token, bookingId: bookingId).then((value) async {
      data = await futureToRun();
      setBusy(false);
      return value;
    });
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

  Future<List<BookingsListResults?>?> getUserBookings() async {
    String? token = await _tokenService.getTokenValue();
    bookingsListModel = await _bookingApiService.getUserBookings(token: token, context: context, page: pageNumber);
    notifyListeners();
    return bookingsListModel!.results!;
  }

  @override
  Future<List<BookingsListResults?>?> futureToRun() async {
    return await getUserBookings();
  }
}