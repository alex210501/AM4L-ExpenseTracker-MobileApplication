import 'package:am4l_expensetracker_mobileapplication/models/api_request.dart';
import 'package:am4l_expensetracker_mobileapplication/models/user.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/api_tools.dart';

const userPath = 'user';

/// Class that manage the request for the User Management
class UserApi {
  final String uri;
  final Map<String, String> appJsonHeader;

  /// Constructor
  UserApi({required this.uri, required this.appJsonHeader});

  /// Create new user in the database
  Future<User> createUser(User user, String password) async {
    final body = {
      'user_password': password,
      ...user.toJson(),
    };

    ApiRequest apiRequest = ApiRequest(
      uri: '$uri/$userPath',
      method: HttpMethod.post,
      body: body,
      headers: appJsonHeader,
    );

    // Get answer from HTTP request
    Map<dynamic, dynamic> response = await sendHttpRequest(apiRequest);

    return User.fromJson(response);
  }
}