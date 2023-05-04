import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';


class LoginScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const LoginScreen({super.key, required this.expensesTrackerApi});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Forms controller
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _login(BuildContext context) {
    /// Get username and password from controller
    final username = _usernameController.text;
    final password = _passwordController.text;

    /// Make API request to login
    widget.expensesTrackerApi.login(username, password)
      .then((_) => Navigator.pushNamed(context, '/space'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child:Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Username"
              ),
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
      ),
    );
  }
}