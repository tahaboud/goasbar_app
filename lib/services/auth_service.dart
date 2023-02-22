// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:goasbar/data_models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/enum/status_code.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<dynamic> register({Map? body}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/register/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } if (response.statusCode == 429) {
        return StatusCode.throttled;
      } else {
        return null;
      }
    });
  }

  Future<bool> verifyPhoneNumber({String? phoneNumber}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/phone-number/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: {
        "phone_number": "$phoneNumber",
        "language_code": "en",
      },
    ).then((response) {

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<AuthResponse> login({Map? body}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/login/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: body,
    ).then((response) async {
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      }
      else {
        return AuthResponse();
      }
    });
  }

  Future<UserModel?> getUserData({String? token}) async {
    return http.get(
      Uri.parse("$baseUrl/api/auth/user/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body)['user']);
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> updateUserData({String? token, Map<String, dynamic>? body,}) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap(body!);

    return dio.patch(
      "$baseUrl/api/auth/user/",
      options: Options(
        headers: {
          "Accept-Language": "en-US",
          "Authorization": "Token $token",
          "Content-Type": "multipart/form-data",
        },
      ),
      data: formData,
    ).then((response) {
      if (response.statusCode == 201) {
        print('update done');
        return UserModel.fromJson(response.data['user']);
      } else {
        return null;
      }
    });
  }

  Future<bool?> requestResetPassword({String? phoneNumber}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/request-password-reset/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: {
        "phone_number": "$phoneNumber",
        "language_code": "en"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool?> resetPassword({String? phoneNumber, String? code, String? password}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/password-reset/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: {
        "phone_number": phoneNumber,
        "verification_code": code,
        "password": password,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> logout({String? token}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/logout/"),
      headers: {
        "Accept-Language": "en-US",
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 204) {
        return true;
      }
      else {
        return false;
      }
    });
  }
}