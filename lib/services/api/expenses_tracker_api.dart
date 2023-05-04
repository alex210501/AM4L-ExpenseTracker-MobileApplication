import 'package:am4l_expensetracker_mobileapplication/models/api_request.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/api_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/space_api.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/user_api.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/user_space_api.dart';

const hostUri = 'https://alejandro-borbolla.com/expensestracker';
const authenticationPath = 'auth';
const loginPath = '$authenticationPath/login';
const logoutPath = '$authenticationPath/logout';
Map<String, String> appJsonHeader = {"Content-Type": "application/json"};

/// Class that manage the API communication
class ExpensesTrackerApi {
  String token = '';
  final String uri = hostUri;
  final spaceApi = SpaceApi(uri: hostUri, appJsonHeader: appJsonHeader);
  final userApi = UserApi(uri: hostUri, appJsonHeader: appJsonHeader);
  final userSpaceApi = UserSpaceApi(uri: hostUri, appJsonHeader: appJsonHeader);

  /// Login to the API, return a token
  Future<void> login(String username, String password) async {
    final body = {
      'username': username,
      'password': password,
    };

    ApiRequest apiRequest = ApiRequest(
        uri: '$uri/$loginPath',
        method: HttpMethod.post,
        body: body,
        headers: appJsonHeader,
    );

    // Make HTTP request
    Map<dynamic, dynamic> response = await sendHttpRequest(apiRequest);

    // Get token from response
    token = response['token'] as  String;
    appJsonHeader['Authorization'] = getTokenHeader(token);
  }

  /// Logout from the API
  void logout() {
    ApiRequest apiRequest = ApiRequest(
        uri: '$uri/$logoutPath',
        method: HttpMethod.post,
        headers: appJsonHeader,
    );
    
    sendHttpRequest(apiRequest).then((_) => token = '');
  }
}