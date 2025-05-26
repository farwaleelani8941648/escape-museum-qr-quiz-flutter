// lib/screen/home_screen.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

import '../provider/player_provider.dart';

/// HomeScreen: Main screen for player name input and QR code generation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for name TextField
  final TextEditingController _nameController = TextEditingController();

  // Controller to capture QR widget as an image
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    // Access player state
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Setup'),
        actions: [
          // Navigate to scan screen
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.pushNamed(context, '/scan');
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name input field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Button to generate QR code
              FilledButton.icon(
                onPressed: () {
                  // Only generate if name is not empty
                  if (_nameController.text.trim().isNotEmpty) {
                    playerProvider.setPlayerName(_nameController.text.trim());
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.qr_code),
                label: const Text('Generate QR Code'),
              ),
              const SizedBox(height: 20),
              // Display QR and save button if a name exists
              if (playerProvider.playerName.isNotEmpty)
                Column(
                  children: [
                    // Widget to show the generated QR code
                    Screenshot(
                      controller: _screenshotController,
                      child: QrImageView(
                        data: playerProvider.playerName,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Button to save QR image to gallery
                    FilledButton.icon(
                      onPressed: _saveQrToGallery,
                      icon: const Icon(Icons.save_alt),
                      label: const Text('Save QR to Gallery'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Saves the QR code image to the device's gallery
  Future<void> _saveQrToGallery() async {
    // Request storage/gallery permissions
    final permission = await Permission.photos.request();
    if (!permission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required.')),
      );
      return;
    }

    // Capture the QR widget as image
    final Uint8List? image = await _screenshotController.capture();
    if (image != null) {
      // Save the image file to a custom directory
      final directory = Directory('/storage/emulated/0/Pictures/QRCodeQuiz');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final file = File('${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR saved to ${directory.path}')),
      );
    }
  }
}

