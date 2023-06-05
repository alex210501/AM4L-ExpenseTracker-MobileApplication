enum HttpMethod { get, post, patch, delete }

/// Contained the data that needs a request
class ApiRequest {
  final String uri;
  final Map<String, String> headers;
  final Map<String, dynamic> body;
  final HttpMethod method;

  /// Constructor
  ///
  /// Create a request to [uri] with an HTTP [method]
  /// Insert some [headers] and [body]
  ApiRequest({
    required this.uri,
    required this.method,
    this.headers = const <String, String>{},
    this.body = const <String, String>{},
  });
}
