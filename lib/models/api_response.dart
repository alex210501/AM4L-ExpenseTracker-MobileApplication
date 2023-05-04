import 'dart:convert';

import 'package:http/http.dart' as http;


/// Container for the API Response
class ApiResponse {
  late final int statusCode;
  late final dynamic content;

  ApiResponse.fromHttpResponse(http.Response response) {
    statusCode = response.statusCode;
    content = jsonDecode(response.body);
  }

  bool isOk() => (statusCode / 100) == 2;
}