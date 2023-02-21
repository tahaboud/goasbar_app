// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/data_models/timing_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:http/http.dart' as http;

class TimingApiService {
  Future<TimingModel?> createTiming({String? token, Map? body, int? experienceId}) async {
    return http.post(
      Uri.parse("$baseUrl/api/experience/provider/timing/$experienceId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 201) {
        return TimingModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<TimingModel?> updateTiming({String? token, Map? body, int? timingId}) async {
    return http.post(
      Uri.parse("$baseUrl/api/experience/provider/timing/$timingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        return TimingModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    });
  }

  Future<TimingListModel?> getTimingsList({String? token, int? experienceId}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/provider/timing/$experienceId/"),
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

  Future<bool?> deleteTiming({String? token, int? timingId}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/experience/provider/timing/$timingId/"),
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