import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

/// Show the camera to scan a QR code
class QrCodeScannerScreen extends StatefulWidget {
  /// Constructor
  const QrCodeScannerScreen({super.key});

  /// Override createState
  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

/// State for QrCodeScannerScreen
class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  /// Function called when the widget is reassembled
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  /// Dispose the controller
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// Function called when the scanner is created
  Function(QRViewController controller) _onQRViewCreated(BuildContext context) {
    // Return the needed function for QRView
    return (QRViewController controller) {
      this.controller = controller;

      /// Listen to a stream when a QR code has been detected
      controller.scannedDataStream.listen((scanData) {
        Navigator.pop(context, scanData.code);
        controller.stopCamera();
      });
    };
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated(context),
        formatsAllowed: const [BarcodeFormat.qrcode],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
