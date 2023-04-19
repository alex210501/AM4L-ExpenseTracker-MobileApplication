import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/api_config.dart' show ApiConfig;

const String apiConfigPath = "assets/configs/api.json";

Future<ApiConfig> loadApiConfig() async {
  return ApiConfig.fromJson(await _loadJsonFile(apiConfigPath));
}

Future<Map<String, dynamic>> _loadJsonFile(String file) async {
  String content = await _loadAsset(file);

  return jsonDecode(content) as Map<String, dynamic>;
}

Future<String> _loadAsset(String file) async {
  return await rootBundle.loadString(file);
}

