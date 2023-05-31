import 'package:flutter/material.dart';


void showErrorDialog(BuildContext context, Exception errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) => ErrorDialog(errorMessage: errorMessage.toString(),),
  );
}

class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  /// Constructor
  const ErrorDialog({ super.key, required this.errorMessage });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Row(
        children: [
          const Icon(Icons.error),
          Expanded(
              child: Text(errorMessage, softWrap: true, maxLines: 5,),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok',),
        ),
      ],
    );
  }
}