import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/chat_token_provider_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';

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
        return jsonDecode(utf8.decode(response.bodyBytes))["firestore_token"];
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Connection Failed', msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<ChatTokenProviderModel?> getProviderFireStoreTokenAndChatId({context, String? token, int? providerId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/chat/$providerId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 201) {
        return ChatTokenProviderModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }
}