import 'package:am4l_expensetracker_mobileapplication/models/api_request.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/api_tools.dart';

const userSpacePath = 'space/:spaceId/user';


/// Class that manage the reqeust for the User Space Management
class UserSpaceApi {
  final String uri;
  final Map<String,String> appJsonHeader;

  /// Constructor
  UserSpaceApi({required this.uri, required this.appJsonHeader});

  /// Add User in the User Space
  Future<void> addUser(String spaceId, String username) async {
    ApiRequest apiRequest = ApiRequest(
        uri: '$uri/${userSpacePath.replaceAll(':spaceId', spaceId)}',
        method: HttpMethod.post,
        body: { 'username': username },
        headers: appJsonHeader,
    );

    // Send HTTP request
    await sendHttpRequest(apiRequest);
  }

  /// Delete User form the Space
  Future<void> deleteUser(String spaceId, String username) async {
    ApiRequest apiRequest = ApiRequest(
        uri: '$uri/${userSpacePath.replaceAll(':spaceId', spaceId)}/$username',
        method: HttpMethod.delete,
        headers: appJsonHeader,
    );

    /// Send HTTP request
    await sendHttpRequest(apiRequest);
  }
}