import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

/// Show the QR code dialog
void showQrCodeDialog(BuildContext context, String qrCodeMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) => QrCodeDialog(qrCodeMessage: qrCodeMessage),
  );
}

/// QR code dialog
class QrCodeDialog extends StatelessWidget {
  final String qrCodeMessage;

  /// Constructor
  const QrCodeDialog({super.key, required this.qrCodeMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan me!'),
      content: SizedBox(
        height: 300,
        child: Container(
          height: 300,
          alignment: Alignment.center,
          child: QrImageView(
            data: qrCodeMessage,
            version: QrVersions.auto,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
