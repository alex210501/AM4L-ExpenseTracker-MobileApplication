import 'package:am4l_expensetracker_mobileapplication/models/api_request.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/api_tools.dart';

const spacePath = 'space';

/// Class that manage the reqeust for the Space Management
class SpaceApi {
  final String uri;
  final Map<String, String> appJsonHeader;

  /// Constructor
  SpaceApi({required this.uri, required this.appJsonHeader});

  /// Get Spaces from the API
  Future<List<Space>> getSpaces() async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/$spacePath',
      method: HttpMethod.get,
      headers: appJsonHeader,
    );

    // Send HTTP request
    List<dynamic> response = await sendHttpRequest(apiRequest);

    // Convert JSON into Spaces
    return response
        .map((value) => Space.fromJson(value as Map<String, dynamic>))
        .toList();
  }

  /// Create space to the API
  Future<Space> createSpace(Space space) async {
    // Create the ody
    var body = {
      'space_name': space.name,
      'space_description': space.description,
    };

    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/$spacePath',
      method: HttpMethod.post,
      body: body,
      headers: appJsonHeader,
    );

    /// Send HTTP request
    Map<String, dynamic> response = await sendHttpRequest(apiRequest);

    return Space.fromJson(response);
  }

  Future<void> updateSpace(Space space) async {
    // Create the ody
    var body = {
      'space_name': space.name,
      'space_description': space.description,
    };

    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/$spacePath/${space.id}',
      method: HttpMethod.patch,
      body: body,
      headers: appJsonHeader,
    );

    // Send HTTP request
    await sendHttpRequest(apiRequest);
  }

  /// Delete space from API
  Future<void> deleteSpace(String spaceId) async {
    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/$spacePath/$spaceId',
      method: HttpMethod.delete,
      headers: appJsonHeader,
    );

    // Send HTTP request
    await sendHttpRequest(apiRequest);
  }
}
