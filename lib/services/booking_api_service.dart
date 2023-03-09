import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';

class BookingApiService {
  final _authService = locator<AuthService>();

  Future<BookingModel?> createBooking({context, String? token, int? timingId, Map? body}) async {
    return http.post(
      Uri.parse("$baseUrl/api/booking/$timingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
        "Accept": "Application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    ).then((response) {
      if (response.statusCode == 201) {
        return BookingModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<String?> prepareCheckout({String? token, int? bookingId, Map? body, context}) async {
    return http.post(
      Uri.parse("$baseUrl/api/booking/payment/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['checkoutId'];
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Error Payment', msg: jsonDecode(response.body)['error'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<bool?> getPaymentStatus({context, String? token, int? bookingId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/booking/payment/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['response'] == "Booking is confirmed") {
          return true;
        }
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return false;
      }
    });
  }
}