import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../provider/player_provider.dart';

/// ScanScreen: Allows user to scan a QR code and sets player name from QR data.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanned = false; // Prevents multiple scans

  /// Callback when QR code is detected
  void _onDetect(BarcodeCapture barcodeCapture) {
    if (_isScanned) return;

    final String? rawValue = barcodeCapture.barcodes.first.rawValue;

    if (rawValue != null && rawValue.trim().isNotEmpty) {
      setState(() {
        _isScanned = true;
      });

      // Save player name from QR code
      final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
      playerProvider.setPlayerName(rawValue.trim());

      // Navigate to Welcome screen after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacementNamed(context, '/welcome');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Camera view for scanning
          Positioned.fill(
            child: Center(
              child: SizedBox(
                height: height * 0.7,
                width: width * 0.9,
                child: MobileScanner(onDetect: _onDetect),
              ),
            ),
          ),
          // Scan instructions at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: Colors.black.withOpacity(0.6),
              child: const Text(
                'Align the QR code within the frame to scan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

