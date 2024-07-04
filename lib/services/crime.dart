import 'dart:convert';
import 'dart:io';

import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/auth.dart';
import 'package:image_picker/image_picker.dart';

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
  XFile? image,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var request = http.MultipartRequest('POST', Uri.parse(userReportedURL))
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..fields['title'] = title ?? ''
      ..fields['description'] = description ?? ''
      ..fields['location'] = 'location'
      ..fields['type'] = type ?? '';

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = "Crime registered";
        break;
      case 401:
        apiResponse.error = jsonDecode(responseData.body)['message'];
        break;
      case 422:
        apiResponse.error = jsonDecode(responseData.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(responseData.body)['message'];
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
