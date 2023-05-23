// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/enum/status_code.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/splash/splash_view.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:goasbar/data_models/cards_model.dart';

class AuthService {
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();

  Future<dynamic> register({Map<String, dynamic>? body, bool? hasImage, context}) async {
    if (hasImage!) {
      Dio dio = Dio();
      FormData formData = FormData.fromMap(body!);

      return dio.post(
        "$baseUrl/api/auth/register/",
        options: Options(
          headers: {
            "Accept-Language": "en-US",
          },
        ),
        data: formData,
      ).then((response) {
        print(response.data);
        if (response.statusCode == 201) {
          return AuthResponse.fromJson(response.data);
        } if (response.statusCode == 429) {
          return StatusCode.throttled;
        } else {
          showMotionToast(context: context, title: 'Registration Failed', msg: response.data["errors"]['detail'], type: MotionToastType.error);
          return null;
        }
      });
    } else {
      return http.post(
        Uri.parse("$baseUrl/api/auth/register/"),
        headers: {
          "Accept-Language": "en-US",
        },
        body: body,
      ).then((response) {
        print(response.body);
        if (response.statusCode == 201) {
          return AuthResponse.fromJson(jsonDecode(response.body));
        } if (response.statusCode == 429) {
          return StatusCode.throttled;
        } else {
          showMotionToast(context: context, title: 'Registration Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
          return null;
        }
      });
    }
  }

  Future<bool> verifyPhoneNumber({String? phoneNumber, context}) async {
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
      print(response.body);
      print(phoneNumber);
      if (response.statusCode == 200) {
        return true;
      } else {
        showMotionToast(context: context, title: 'Phone Verification Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }

  Future<AuthResponse> login({Map? body, context}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/login/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: body,
    ).then((response) async {
      print(response.body);
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      }
      else {
        showMotionToast(context: context, title: 'login Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return AuthResponse();
      }
    });
  }

  Future<UserModel?> getUserData({String? token, context}) async {
    return http.get(
      Uri.parse("$baseUrl/api/auth/user/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body)['user']);
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<String?> getUserPicture({String? token, context, int? userId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/auth/user-picture/$userId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['response']["image"];
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> updateFavoritesUser({String? token, Map<String, dynamic>? body, context}) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap(body!);

    return dio.patch(
      "$baseUrl/api/auth/user/",
      options: Options(
        headers: {
          "Accept-Language": "en-US",
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      ),
      data: formData,
    ).then((response) {
      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data['user']);
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Update Favorites Failed', msg: response.data["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<UserModel?> updateUserData({String? token, Map<String, dynamic>? body, context}) async {
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
        return UserModel.fromJson(response.data['user']);
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Update Failed', msg: response.data["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<bool?> requestResetPassword({String? phoneNumber, context}) async {
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
        showMotionToast(context: context, title: 'Request Password Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }

  Future<bool?> resetPassword({String? phoneNumber, String? code, String? password, context}) async {
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
        showMotionToast(context: context, title: 'Reset Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }

  Future<CardsModel?> getUserCards({String? token, context,}) async {
    return http.get(
      Uri.parse("$baseUrl/api/auth/cards/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        return CardsModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<String?> getRegistrationId({String? token, context, body}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/cards/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 201) {
        return jsonDecode(response.body)['id'];
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<String?> getRegistrationStatus({id, String? token, context, cardType}) async {
    return http.put(
      Uri.parse("$baseUrl/api/auth/cards/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: {
        "checkout_id": id,
        "card_type": cardType,
      },
    ).then((response) {
      print("----------------------------");
      print(response.body);
      print("----------------------------");
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['id'];
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  //TODO not working
  Future<String?> saveNewCard({String? token, context, body}) async {
    return http.put(
      Uri.parse("$baseUrl/api/auth/cards/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      print(response.body);
      if (response.statusCode == 201) {
        return "null";
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Save Card Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<bool?> logout({String? token, context}) async {
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
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Logout Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }

  unAuthClearAndRestart({BuildContext? context}) {
    showMotionToast(context: context!, type: MotionToastType.error, msg: "Your session has expired, you must login again", title: 'Unauthorized');
    _tokenService.clearToken();
    Timer(const Duration(milliseconds: 1000), () {
      _navigationService.clearStackAndShowView(const SplashView());
    });
  }
}