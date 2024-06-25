import 'dart:convert';

import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> registerSurvey(
  String? q1,
  String? q2,
  String? q3,
  String? q4,
  String? q5,
  String? q6,
  String? q7,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(userSurveysURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'q1': q1,
      'q2': q2,
      'q3': q3,
      'q4': q4,
      'q5': q5,
      'q6': q6,
      'q7': q7,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Survey registered";
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 500:
        apiResponse.error = 'Server error';
        break;
      default:
        apiResponse.error = 'Something went wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error';
  }

  return apiResponse;
}
