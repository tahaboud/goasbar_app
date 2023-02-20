import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goasbar/data_models/experience_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/shared/app_configs.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:goasbar/data_models/provider_model.dart';

class ExperienceApiService {
  Future<ExperienceResults?> createExperience({String? token, Map<String, dynamic>? body}) async {
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
      } else {
        return null;
      }
    });
  }

  Future<ExperienceModel?> getProviderExperiences({String? token}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/provider/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ExperienceModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<ExperienceModel?> getPublicExperiences({String? token, String? query}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/?$query"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return ExperienceModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<TimingListModel?> getExperiencePublicTimings({String? token, String? experienceId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/timing/?$experienceId"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return TimingListModel.fromJson(jsonDecode(response.body));
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

  Future<bool?> deleteExperience({String? token, int? experienceId}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/experience/provider/$experienceId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }
}