// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/data_models/timing_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:http/http.dart' as http;

class ReviewApiService {
  final _authService = locator<AuthService>();

  //TODO add review model
  Future<TimingModel?> createReview({context, String? token, Map? body, int? bookingId}) async {
    return http.post(
      Uri.parse("$baseUrl/api/review/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 201) {
        return TimingModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
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