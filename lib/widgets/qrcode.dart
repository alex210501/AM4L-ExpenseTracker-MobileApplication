import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

/// Show a container that display the QR code
class QrCode extends StatelessWidget {
  final String qrCodeMessage;
  final Function(BuildContext) onPressed;

  /// Constructor
  const QrCode({super.key, required this.qrCodeMessage, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 5.0, // Shadow blur radius
              spreadRadius: 20.0, // Shadow spread radius
              offset: const Offset(0, 0), // Shadow offset
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QrImageView(
                      data: qrCodeMessage,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    TextButton(onPressed: () => onPressed(context), child: const Text("Ok")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
