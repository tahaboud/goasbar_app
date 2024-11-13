// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/auth_response.dart';
import 'package:goasbar/data_models/cards_model.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/token_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/splash/splash_view.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthService {
  final _navigationService = locator<NavigationService>();
  final _tokenService = locator<TokenService>();

  Future<String> register({Map<String, dynamic>? body, bool? hasImage}) async {
    if (hasImage!) {
      Dio dio = Dio();
      FormData formData = FormData.fromMap(body!);
      return dio
          .post(
        "$baseUrl/api/auth/register/",
        options: Options(
          headers: {
            "Accept-Language": "en-US",
          },
        ),
        data: formData,
      )
          .then((response) {
        if (response.statusCode == 201) {
          _tokenService
              .setTokenValue(AuthResponse.fromJson(response.data).token!);
          return "success";
        }
        return response.data["errors"][0]['detail'] as String;
      }).catchError((error) {
        if (error.runtimeType == DioException) {
          if ([400, 429].contains(error.response.statusCode)) {
            return error.response.data["errors"][0]["detail"] as String;
          }
        }
        return "internal_error";
      });
    } else {
      return http
          .post(
        Uri.parse("$baseUrl/api/auth/register/"),
        headers: {
          "Accept-Language": "en-US",
        },
        body: body,
      )
          .then((response) {
        if (response.statusCode == 201) {
          _tokenService.setTokenValue(
              AuthResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
                  .token!);
          return "success";
        }
        return jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
            ['detail'] as String;
      }).catchError((error) {
        return "internal_error";
      });
    }
  }

  Future<String> checkVerificationCode(
      {Map<String, dynamic>? body, context}) async {
    return http
        .post(
      Uri.parse("$baseUrl/api/auth/check-code/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 200) {
        return "validOTP";
      }
      if (response.statusCode == 429) {
        return jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
            ['detail'];
      }
      if (response.statusCode == 400) {
        return "invalidOTP";
      }
      return "serverError";
    });
  }

  Future<String> verifyPhoneNumber({String? phoneNumber, context}) async {
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
        return "OTP sent";
      } else {
        return jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
            ['detail'];
      }
    });
  }

  Future<Object> login({Map? body, context}) async {
    return http
        .post(
      Uri.parse("$baseUrl/api/auth/login/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: body,
    )
        .then((response) async {
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        return jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
            ['detail'];
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
      if (response.statusCode == 200) {
        return UserModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes))['user']);
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
          context: context,
        );
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
        return jsonDecode(utf8.decode(response.bodyBytes))['response']["image"];
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> updateFavoritesUser(
      {String? token, Map<String, dynamic>? body, context}) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap(body!);

    return dio
        .patch(
      "$baseUrl/api/auth/user/",
      options: Options(
        headers: {
          "Accept-Language": "en-US",
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      ),
      data: formData,
    )
        .then((response) {
      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data['user']);
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Update Favorites Failed',
            msg: response.data["errors"]['detail'],
            type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<UserModel?> updateUserData(
      {String? token, Map<String, dynamic>? body, context}) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap(body!);

    return dio
        .patch(
      "$baseUrl/api/auth/user/",
      options: Options(
        headers: {
          "Accept-Language": "en-US",
          "Authorization": "Token $token",
          "Content-Type": "multipart/form-data",
        },
      ),
      data: formData,
    )
        .then((response) {
      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data['user']);
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Update Failed',
            msg: response.data["errors"]['detail'],
            type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<String> requestResetPassword({String? phoneNumber, context}) async {
    return http.post(
      Uri.parse("$baseUrl/api/auth/request-password-reset/"),
      headers: {
        "Accept-Language": "en-US",
      },
      body: {"phone_number": "$phoneNumber", "language_code": "en"},
    ).then((response) {
      if (response.statusCode == 200) {
        return "request_reset_password_otp_sent";
      } else {
        return jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
            ['detail'];
      }
    });
  }

  Future<bool?> resetPassword(
      {String? phoneNumber, String? code, String? password, context}) async {
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
        showMotionToast(
            context: context,
            title: 'Reset Failed',
            msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
                ['detail'],
            type: MotionToastType.error);
        return false;
      }
    });
  }

  Future<CardsModel?> getUserCards({
    String? token,
    context,
  }) async {
    return http.get(
      Uri.parse("$baseUrl/api/auth/cards/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return CardsModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        return null;
      }
    });
  }

  Future<String?> getRegistrationId({String? token, context, body}) async {
    return http
        .post(
      Uri.parse("$baseUrl/api/auth/cards/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 201) {
        return jsonDecode(utf8.decode(response.bodyBytes))['id'];
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        return null;
      }
    });
  }

  Future<String?> saveCardAndGetRegistrationStatus(
      {id, String? token, context, cardType}) async {
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
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes))['id'];
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
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
        unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Logout Failed',
            msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
                ['detail'],
            type: MotionToastType.error);
        return false;
      }
    });
  }

  Future<bool?> deleteAccount({String? token, context}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/auth/delete/"),
      headers: {
        "Accept-Language": "en-US",
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        unAuthClearAndRestart(
          context: context,
        );
        return null;
      } else {
        showMotionToast(
            context: context,
            title: 'Delete Account Failed',
            msg: jsonDecode(utf8.decode(response.bodyBytes))["errors"][0]
                ['detail'],
            type: MotionToastType.error);
        return false;
      }
    });
  }

  unAuthClearAndRestart({BuildContext? context}) {
    showMotionToast(
        context: context!,
        type: MotionToastType.error,
        msg: "Your session has expired, you must login again",
        title: 'Unauthorized');
    _tokenService.clearToken();
    Timer(const Duration(milliseconds: 1000), () {
      _navigationService.clearStackAndShowView(const SplashView());
    });
  }
}
