const String defaultHost = "192.168.1.121";
const int defaultPort = 8080;

/// Container for the configurations of the API
class ApiConfig {
  String host;
  int port;

  /// Construtor
  ApiConfig({required this.host, required this.port});

  /// Construtor from JSON
  ApiConfig.fromJson(Map<String, dynamic> jsonData)
      : host = (jsonData['host'] ?? defaultHost) as String,
        port = (jsonData['port'] ?? defaultPort) as int;
}
