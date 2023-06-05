enum HttpMethod { get, post, patch, delete }

/// Contained the data that needs a request
class ApiRequest {
  final String uri;
  final Map<String, String> headers;
  final Map<String, dynamic> body;
  final HttpMethod method;

  ApiRequest({
    required this.uri,
    required this.method,
    this.headers = const <String, String>{},
    this.body = const <String, String>{},
  });
}