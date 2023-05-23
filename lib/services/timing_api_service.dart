// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/timing_list_model.dart';
import 'package:goasbar/data_models/timing_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';

class TimingApiService {
  final _authService = locator<AuthService>();

  Future<TimingModel?> createTiming({context, String? token, Map? body, int? experienceId}) async {
    return http.post(
      Uri.parse("$baseUrl/api/experience/provider/timing/$experienceId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      print(response.body);
      if (response.statusCode == 201) {
        return TimingModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Create Timing Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<TimingModel?> updateTiming({String? token, Map? body, int? timingId, context}) async {
    return http.post(
      Uri.parse("$baseUrl/api/experience/provider/timing/$timingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      if (response.statusCode == 200) {
        return TimingModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Update Timing Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<TimingListModel?> getTimingsList({String? token, int? experienceId, context, int? page}) async {
    return http.get(
      Uri.parse("$baseUrl/api/experience/provider/timing/$experienceId/?page=$page"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return TimingListModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        return null;
      }
    });
  }

  Future<bool?> deleteTiming({String? token, int? timingId, context}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/experience/provider/timing/$timingId/"),
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
        showMotionToast(context: context, title: 'Delete Timing Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }
}