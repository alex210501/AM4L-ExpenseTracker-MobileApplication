import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:am4l_expensetracker_mobileapplication/models/api/api_response.dart';
import 'package:am4l_expensetracker_mobileapplication/models/api/api_request.dart';

/// Send http request and throw error if status code is not 200
Future<dynamic> sendHttpRequest(ApiRequest apiRequest) async {
  ApiResponse response = ApiResponse.fromHttpResponse(await _makeRequest(apiRequest));

  // Check the status code
  if (response.isOk()) {
    return response.content;
  }

  // The error received is a JSON
  throw Exception(response.content['msg'] ?? 'Unknown error');
}

/// Get the bearer token
String getTokenHeader(String token) => 'Bearer $token';

/// Make the actual HTTP request
Future<http.Response> _makeRequest(ApiRequest apiRequest) {
  final uri = Uri.parse(apiRequest.uri);
  final body = jsonEncode(apiRequest.body);

  switch (apiRequest.method) {
    case HttpMethod.get:
      return http.get(uri, headers: apiRequest.headers);
    case HttpMethod.post:
      return http.post(uri, headers: apiRequest.headers, body: body);
    case HttpMethod.patch:
      return http.patch(uri, headers: apiRequest.headers, body: body);
    case HttpMethod.delete:
      return http.delete(uri, headers: apiRequest.headers, body: body);
    default:
      return http.get(uri, headers: apiRequest.headers);
  }
}
