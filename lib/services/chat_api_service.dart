import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/chat_token_provider_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ChatApiService {
  final _authService = locator<AuthService>();

  Future<String?> getUserFireStoreToken({context, String? token}) async {
    return http.get(
      Uri.parse("$baseUrl/api/chat/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 201) {
        return jsonDecode(response.body)["firestore_token"];
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<ChatTokenProviderModel?> getUserFireStoreTokenAndProviderChatId({context, String? token, int? providerId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/chat/$providerId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 201) {
        return ChatTokenProviderModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }


}