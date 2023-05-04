import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/user.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';


class CreateUserScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const CreateUserScreen({super.key, required this.expensesTrackerApi});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  /// Create User
  _createUser(BuildContext context) {
    User user = User(username: '4', firstname: '2', lastname: '2', email: '2');

    widget.expensesTrackerApi.userApi.createUser(user, 'yop')
        .then((_) => Navigator.pushNamed(context, '/login'))
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Username"),
                validator: (text) {
                  return (text == null || text.isEmpty) ? "Username must be filled!" : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Firstname"),
                validator: (text) {
                  return (text == null || text.isEmpty) ? "Firstname must be filled!" : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Lastname"),
                validator: (text) {
                  return (text == null || text.isEmpty) ? "Lastname must be filled!" : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Email"),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Username must be filled!";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
                validator: (text) {
                  return (text == null || text.isEmpty) ? "Password must be filled!" : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Retype password"),
                obscureText: true,
                validator: (text) {
                  return (text == null || text.isEmpty) ? "Password must be filled!" : null;
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text("Sign in"),
                  ),
                  ElevatedButton(
                    onPressed: () => _createUser(context),
                    child: const Text("Create"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
