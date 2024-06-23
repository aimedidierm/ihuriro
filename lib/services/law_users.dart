import 'dart:convert';

import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> register(
  String? name,
  String? email,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse(governmentLawUsersdURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'name': name,
      'email': email,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = "User registered";
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
