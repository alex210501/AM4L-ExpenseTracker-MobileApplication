import 'dart:convert';

import 'package:http/http.dart' as http;

/// Container for the API Response
class ApiResponse {
  late final int statusCode;
  late final dynamic content;

  /// Constructor from an http [response]
  ApiResponse.fromHttpResponse(http.Response response) {
    statusCode = response.statusCode;

    // Decode JSON content
    try {
      content = jsonDecode(response.body);
    } catch (_) {
      content = <dynamic, dynamic>{};
    }
  }

  /// Check if the status code is valid
  bool isOk() => (statusCode / 100) == 2;
}
