import 'package:flutter/material.dart';


/// Store the credentials of the current user
class CredentialsModel extends ChangeNotifier {
  String _username = '';

  /// Getter for the username
  String get username {
    return _username;
  }

  /// Setter for the username
  set username(String newUsername) {
    _username = newUsername;

    notifyListeners();
  }

  /// Clear credentials
  void clear() {
    _username = '';
  }
}