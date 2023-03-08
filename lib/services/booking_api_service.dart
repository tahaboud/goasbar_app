import 'dart:convert';

import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/shared/app_configs.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class BookingApiService {
  Future<BookingModel?> createBooking({String? token, int? timingId, Map? body}) async {
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
      print(response.body);
      if (response.statusCode == 201) {
        return BookingModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<String?> prepareCheckout({String? token, int? bookingId, Map? body}) async {
    return http.post(
      Uri.parse("$baseUrl/api/booking/payment/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['checkoutId'];
      } else {
        return null;
      }
    });
  }

  Future<String?> getPaymentStatus({String? token, int? bookingId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/booking/payment/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['response'];
      } else {
        return null;
      }
    });
  }
}