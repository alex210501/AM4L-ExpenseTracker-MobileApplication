import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Function(QRViewController controller) _onQRViewCreated(BuildContext context) {
    // Return the needed function for QRView
    return (QRViewController controller) {
      this.controller = controller;

      controller.scannedDataStream.listen((scanData) {
        Navigator.pop(context, scanData.code);
        controller.stopCamera();
      });
    };
  }

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
