import 'package:am4l_expensetracker_mobileapplication/models/api_config.dart';
import 'package:am4l_expensetracker_mobileapplication/models/api_request.dart';
import 'package:am4l_expensetracker_mobileapplication/modules/file_manager.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/api_tools.dart';

const hostUri = 'https://alejandro-borbolla.com/expensestracker';
const authenticationPath = 'auth';
const loginPath = '$authenticationPath/login';
const logoutPath = '$authenticationPath/logout';
const appJsonHeader = {"Content-Type": "application/json"};

/// Class that manage the API communication
class ExpensesTrackerApi {
  String token = '';
  final String uri = hostUri;

  /// Login to the API, return a token
  void login(String username, String password) {
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

    sendHttpRequest(apiRequest).then((content) {token = content['token'] as  String; print(token);}).catchError((err) => print(err));
  }

  /// Logout from the API
  void logout() {
    ApiRequest apiRequest = ApiRequest(
        uri: '$uri/$logoutPath',
        method: HttpMethod.post,
        headers: {'Authorization': getTokenHeader(token), ...appJsonHeader },
    );
    
    sendHttpRequest(apiRequest).then((_) => token = '');
  }
}