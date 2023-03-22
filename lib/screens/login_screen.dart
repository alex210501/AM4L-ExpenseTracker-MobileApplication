import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
              validator: (text) {
                return (text == null || text.isEmpty) ? "Username must be filled!" : null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Password",
              ),
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
                    onPressed: () => print("Connect"),
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