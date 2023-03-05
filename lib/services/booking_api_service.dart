import 'dart:convert';

import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/data_models/public_provider_model.dart';
import 'package:goasbar/shared/app_configs.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:goasbar/data_models/provider_model.dart';

class BookingApiService {
  Future<BookingModel?> createBooking({String? token, int? timingId}) async {
    return http.post(
      Uri.parse("$baseUrl/api/booking/$timingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
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

  Future<ProviderModel?> getProviderUserInfo({String? token}) async {
    return http.get(
      Uri.parse("$baseUrl/api/provider/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ProviderModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<PublicProviderModel?> getProviderInfo({int? providerId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/provider/$providerId/"),
      headers: {
        "Accept-Language": "en-US",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return PublicProviderModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<ProviderModel?> updateProvider({String? token, Map? body}) async {
    return http.patch(
      Uri.parse("$baseUrl/api/provider/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 200) {
        return ProviderModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }
}