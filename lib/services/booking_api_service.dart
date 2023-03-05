import 'dart:convert';

import 'package:goasbar/data_models/public_provider_model.dart';
import 'package:goasbar/shared/app_configs.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:goasbar/data_models/provider_model.dart';

class BookingApiService {
  Future<ProviderModel?> createProvider({String? token, Map? body}) async {
    return http.post(
      Uri.parse("$baseUrl/api/provider/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 201) {
        return ProviderModel.fromJson(jsonDecode(response.body));
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