import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/data_models/bookings_list_model.dart';
import 'package:goasbar/data_models/provider_timing_booking.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';

class BookingApiService {
  final _authService = locator<AuthService>();

  Future<BookingModel?> createBooking(
      {context, String? token, int? timingId, Map? body}) async {
    return http
        .post(
      Uri.parse("$baseUrl/api/booking/$timingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
        "Accept": "Application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    )
        .then((response) {
      if (response.statusCode == 201) {
        return BookingModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Create Booking Failed',
            msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
                ['detail'],
            type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<String?> prepareCheckout(
      {String? token, int? bookingId, Map? body, context}) async {
    return http
        .post(
      Uri.parse("$baseUrl/api/booking/payment/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes))['checkoutId'];
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Prepare Checkout Failed',
            msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
                ['detail'],
            type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<bool?> getPaymentStatus({
    context,
    String? token,
    int? bookingId,
  }) async {
    return http.get(
      Uri.parse("$baseUrl/api/booking/payment/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        return false;
      }
    });
  }

  Future<BookingsListModel?> getUserBookings(
      {context, String? token, int? page, String? query = ''}) async {
    return http.get(
      Uri.parse("$baseUrl/api/booking/?page=$page&$query"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return BookingsListModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        return null;
      }
    });
  }

  Future<ProviderTimingBooking?> getProviderTimingBookings(
      {context, String? token, int? timingId, int? page}) async {
    return http.get(
      Uri.parse("$baseUrl/api/booking/provider/$timingId/?page=$page"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ProviderTimingBooking.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        return null;
      }
    });
  }

  Future<bool?> deleteBooking({String? token, int? bookingId, context}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/booking/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Delete Booking Failed',
            msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
                ['detail'],
            type: MotionToastType.error);
        return false;
      }
    });
  }
}
