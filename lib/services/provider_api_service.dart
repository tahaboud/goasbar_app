import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/provider_public_experience_model.dart';
import 'package:goasbar/data_models/public_provider_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:goasbar/data_models/provider_model.dart';

class ProviderApiService {
  final _authService = locator<AuthService>();

  Future<ProviderModel?> createProvider({context, String? token, Map? body}) async {
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
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<ProviderModel?> getProviderUserInfo({context, String? token}) async {
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

  Future<PublicProviderModel?> getPublicProviderInfo({int? providerId}) async {
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

  Future<ProviderPublicExperienceModel?> getProviderPublicExperiences({int? providerId, int? page}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/provider/public/$providerId/?page=$page"),
      headers: {
        "Accept-Language": "en-US",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ProviderPublicExperienceModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<ProviderModel?> updateProvider({context, String? token, Map? body}) async {
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
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }
}