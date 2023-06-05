import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/user.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/error_dialog.dart';

/// User that create a new user
class CreateUserScreen extends StatefulWidget {
  /// Constructor
  const CreateUserScreen({super.key});

  /// Override createState
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

/// State for CreateUserScreen
class _CreateUserScreenState extends State<CreateUserScreen> {
  /// Create User
  _createUser(BuildContext context, User user, String password) {
    // Get the ExpensesTrackerApi from context
    final expensesTrackerApi = getExpensesTrackerApiModel(context).expensesTrackerApi;

    // Make request to create user
    expensesTrackerApi.userApi
        .createUser(user, password)
        .then((_) => Navigator.pushNamed(context, '/login'))
        .catchError((err) => showErrorDialog(context, err));
  }

  /// On SignIn action
  _onSignIn(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User"),
      ),
      body: _SignUpForm(
        onCreate: _createUser,
        onSignIn: _onSignIn,
      ),
    );
  }
}

/// Formt to SignUp a new user
class _SignUpForm extends StatefulWidget {
  final void Function(BuildContext, User, String) onCreate;
  final void Function(BuildContext) onSignIn;

  /// Constructor with [onCreate] and [onSignIn]
  const _SignUpForm({
    required this.onCreate,
    required this.onSignIn,
  });

  /// Override createState
  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

/// State for _SignUpForm
class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  /// Callback when a user is created
  void _onCreate(BuildContext context) {
    /// Create a user if the form is valid
    if (_formKey.currentState!.validate()) {
      User user = User(
        username: _usernameController.text,
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
      );
      String password = _passwordController.text;

      // Call the super onCreate
      widget.onCreate(context, user, password);
    }
  }

  /// Dispose all the controllers
  @override
  void dispose() {
    // Clear ressources used by TextEditingController
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(hintText: "Username"),
              validator: (text) {
                return (text == null || text.isEmpty) ? "Username must be filled!" : null;
              },
            ),
            TextFormField(
              controller: _firstnameController,
              decoration: const InputDecoration(hintText: "Firstname"),
              validator: (text) {
                return (text == null || text.isEmpty) ? "Firstname must be filled!" : null;
              },
            ),
            TextFormField(
              controller: _lastnameController,
              decoration: const InputDecoration(hintText: "Lastname"),
              validator: (text) {
                return (text == null || text.isEmpty) ? "Lastname must be filled!" : null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: "Email"),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "Username must be filled!";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: "Password"),
              obscureText: true,
              validator: (text) {
                return (text == null || text.isEmpty) ? "Password must be filled!" : null;
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(hintText: "Retype password"),
              obscureText: true,
              validator: (text) {
                final password = _passwordController.text;
                final confirmPassword = _confirmPasswordController.text;

                if (text == null || text.isEmpty) {
                  return "Password must be filled!";
                }

                if (password != confirmPassword) {
                  return "Passwords must match!";
                }

                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => widget.onSignIn(context),
                    child: const Text("Sign in"),
                  ),
                  ElevatedButton(
                    onPressed: () => _onCreate(context),
                    child: const Text("Create"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
