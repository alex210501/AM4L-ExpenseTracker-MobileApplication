import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import 'package:am4l_expensetracker_mobileapplication/models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/api_loading_indicator.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/error_dialog.dart';


class LoginScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const LoginScreen({super.key, required this.expensesTrackerApi});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  /// Forms controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _setLoading(bool loadingState) {
    setState(() {
      _isLoading = loadingState;
    });
  }

  void _login(BuildContext context) {
    // Get the SpacesListModel from context
    final spacesListModel = Provider.of<SpacesListModel>(context, listen: false);
    final expensesListModel = Provider.of<ExpensesListModel>(context, listen: false);

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
    widget.expensesTrackerApi.login(username, password).then((_) {
      // Refresh spaces
      widget.expensesTrackerApi.spaceApi.getSpaces().then((spaces) {
        spacesListModel.setSpaces(spaces);
        Navigator.pushNamed(context, '/space');

        _setLoading(false);
      });
    }).catchError((err) {
      _setLoading(false);
      showErrorDialog(context, err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Stack(children: [
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
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (text) {
                    return (text == null || text.isEmpty) ? "Password must be filled!" : null;
                  },
                ),
                Row(
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
                )
              ],
            ),
          ),
          if (_isLoading) const ApiLoadingIndicator(),
        ]),
      ),
    );
  }
}
