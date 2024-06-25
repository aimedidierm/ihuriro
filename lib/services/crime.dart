import 'dart:convert';

import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/auth.dart';

Future<ApiResponse> register(
  String? title,
  String? description,
  String? type,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(annonymousURL), headers: {
      'Accept': 'application/json',
    }, body: {
      'title': title,
      'description': description,
      'location': 'location',
      'type': type,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Crime registered";
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

Future<ApiResponse> userRegister(
  String? title,
  String? description,
  String? type,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(userReportedURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'title': title,
      'description': description,
      'location': 'location',
      'type': type,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Crime registered";
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
