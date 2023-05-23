import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';

class ExperienceApiService {
  final _authService = locator<AuthService>();

  Future<ExperienceResults?> createExperience({String? token, Map<String, dynamic>? body, BuildContext? context}) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap(body!);

    return dio.post(
      "$baseUrl/api/experience/provider/",
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
        return ExperienceResults.fromJson(response.data['response']);
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Create Experience Failed', msg: response.data["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<ExperienceModel?> getProviderExperiences({String? token, context, int? page}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/provider/?page=$page"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ExperienceModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<ExperienceModel?> getPublicExperiences({String? query, int? page}) async {
    return http.get(
      Uri.parse(query != null && query.isNotEmpty ? "$baseUrl/api/experience/$query&page=$page" : "$baseUrl/api/experience/?page=$page"),
      headers: {
        "Accept-Language": "en-US",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ExperienceModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        return null;
      }
    });
  }

  Future<TimingListModel?> getExperiencePublicTimings({int? experienceId, int? page}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/timing/$experienceId/?page=$page"),
      headers: {
        "Accept-Language": "en-US",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return TimingListModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<ExperienceResults?> updateExperience({String? token, bool? hasImages, Map<String, dynamic>? body, int? experienceId, context}) async {
    if (hasImages!) {
      Dio dio = Dio();
      FormData formData = FormData.fromMap(body!);

      return dio.patch(
        "$baseUrl/api/experience/provider/$experienceId/",
        options: Options(
          headers: {
            "Accept-Language": "en-US",
            "Authorization": "Token $token",
            "Accept": "Application/json",
            "Content-Type": "application/json"
          },
        ),
        data: formData,
      ).then((response) {
        if (response.statusCode == 200) {
          return ExperienceResults.fromJson(response.data);
        } else if (response.statusCode == 401) {
          _authService.unAuthClearAndRestart(context: context,);
          return null;
        } else {
          showMotionToast(context: context, title: 'Update Experience Failed', msg: response.data["errors"]['detail'], type: MotionToastType.error);
          return null;
        }
      });
    } else {
      return http.patch(
        Uri.parse("$baseUrl/api/experience/provider/$experienceId/"),
        headers: {
          "Accept-Language": "en-US",
          "Authorization": "Token $token",
          "Accept": "Application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      ).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          return ExperienceResults.fromJson(jsonDecode(response.body));
        } else if (response.statusCode == 401) {
          _authService.unAuthClearAndRestart(context: context,);
          return null;
        } else {
          showMotionToast(context: context, title: 'Error', msg: jsonDecode(response.body)["errors"][0]['detail'], type: MotionToastType.error);
          return null;
        }
      });
    }
  }

  Future<bool?> deleteExperience({String? token, int? experienceId, context}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/experience/provider/$experienceId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Delete Experience Failed', msg: jsonDecode(response.body)["errors"][0]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }

  Future<bool?> deleteExperienceImage({String? token, int? imageId, context}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/experience/images/$imageId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Update Experience Image Failed', msg: jsonDecode(response.body)["errors"][0]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }
}