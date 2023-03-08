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
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

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
        return null;
      }
    });
  }

  Future<ExperienceModel?> getProviderExperiences({String? token, context}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/provider/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ExperienceModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<ExperienceModel?> getPublicExperiences({String? query}) async {
    return http.get(
      Uri.parse(query != null ? "$baseUrl/api/experience/$query" : "$baseUrl/api/experience/"),
      headers: {
        "Accept-Language": "en-US",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ExperienceModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<TimingListModel?> getExperiencePublicTimings({int? experienceId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/timing/$experienceId/"),
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

  Future<ExperienceResults?> updateExperience({String? token, Map<String, dynamic>? body, int? experienceId, context}) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap(body!);

    if (body.keys.contains("image")) {
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
        if (response.statusCode == 200) {
          return ExperienceResults.fromJson(jsonDecode(response.body));
        } else if (response.statusCode == 401) {
          _authService.unAuthClearAndRestart(context: context,);
          return null;
        } else {
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
        return false;
      }
    });
  }
}