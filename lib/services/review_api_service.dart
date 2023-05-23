// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/review_model.dart';
import 'package:goasbar/data_models/review_models/reviews_list_model.dart';
import 'package:goasbar/services/auth_service.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/resources/arrays.dart';

class ReviewApiService {
  final _authService = locator<AuthService>();

  Future<ReviewModel?> createReview({context, String? token, Map? body, int? bookingId}) async {
    return http.post(
      Uri.parse("$baseUrl/api/review/$bookingId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      print(response.body);
      if (response.statusCode == 201) {
        return ReviewModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Create Review Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  Future<ReviewModel?> updateReview({String? token, Map? body, int? reviewId, context}) async {
    return http.patch(
      Uri.parse("$baseUrl/api/review/$reviewId/"),
      headers: {
        "Accept-Language": "en-US",
        "Authorization": "Token $token",
      },
      body: body,
    ).then((response) {
      print(body);
      print(response.body);
      if (response.statusCode == 200) {
        return ReviewModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        _authService.unAuthClearAndRestart(context: context,);
        return null;
      } else {
        showMotionToast(context: context, title: 'Update Review Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return null;
      }
    });
  }

  //TODO not working
  Future<bool?> deleteReview({String? token, int? reviewId, context}) async {
    return http.delete(
      Uri.parse("$baseUrl/api/review/$reviewId/"),
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
        showMotionToast(context: context, title: 'Delete Review Failed', msg: jsonDecode(response.body)["errors"]['detail'], type: MotionToastType.error);
        return false;
      }
    });
  }
}