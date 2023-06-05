import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/api_loading_indicator.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/error_dialog.dart';

/// Screen used to log into the application
class LoginScreen extends StatefulWidget {
  /// Constructor
  const LoginScreen({super.key});

  /// Override createState
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// State or LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false; // Display a loading dialog while fetching data
  final _formKey = GlobalKey<FormState>();

  /// Forms controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Set the [_isLoading] variable
  void _setLoading(bool loadingState) => setState(() => _isLoading = loadingState);

  /// Callback called when you want to log a user
  void _login(BuildContext context) {
    // Get ExpensesTrackerApi from context
    final expensesTrackerApi = getExpensesTrackerApiModel(context).expensesTrackerApi;

    // Get the SpacesListModel from context
    final spacesListModel = getSpacesListModel(context);
    final expensesListModel = getExpensesListModel(context);

    // Clear the information memorized from last session
    spacesListModel.clearSpaces();
    expensesListModel.clearExpenses();

    // Set loading mode
    _setLoading(true);

    // Close the keyboard
    FocusScope.of(context).unfocus();

    // Get username and password from controller
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Make API request to login
    expensesTrackerApi.login(username, password).then((_) {
      // Refresh spaces
      expensesTrackerApi.spaceApi.getSpaces().then((spaces) {
        spacesListModel.setSpaces(spaces);
        Navigator.pushNamed(context, '/space');

        // Set the credential to the current username
        getCredentialsModel(context).username = username;

        _setLoading(false);
      });
    }).catchError((err) {
      _setLoading(false);
      showErrorDialog(context, err);
    });
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Username"),
                      controller: _usernameController,
                      validator: (text) {
                        return (text == null || text.isEmpty) ? "Username must be filled!" : null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Password"),
                      controller: _passwordController,
                      obscureText: true,
                      validator: (text) {
                        return (text == null || text.isEmpty) ? "Password must be filled!" : null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/create-user'),
                            child: const Text("Sign up"),
                          ),
                          ElevatedButton(
                            onPressed: () => _login(context),
                            child: const Text("Connect"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading) const ApiLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
