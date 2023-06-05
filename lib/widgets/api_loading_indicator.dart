import 'dart:ui';
import 'package:flutter/material.dart';

/// Circular progress indicator for login
class ApiLoadingIndicator extends StatelessWidget {
  /// Construtor
  const ApiLoadingIndicator({super.key});

  /// Override build
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(50.0),
          decoration:
              BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(10)),
          child: const CircularProgressIndicator(
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }
}
