import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Needed
import 'package:image_picker/image_picker.dart'; // Needed
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' as mlkit;
import 'package:qr_code_andr/widgets/mobile_scanner_simple.dart';
import 'package:qr_code_andr/routes/route_name.dart';
import 'package:qr_code_andr/services/qr_code_service.dart';
import 'package:qr_code_andr/services/login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final MobileScannerController _controller = MobileScannerController();
  final QrCodeService _qrCodeService = QrCodeService();

  Future<void> _onQRDetect(String code) async {
    print("Scanned: $code");
    // Save the QR code to the database
    await _qrCodeService.saveQrCode(code);
    Navigator.pushNamed(context, RouteName.results);
  }

  Future<void> _toggleFlash() async {
    _controller.toggleTorch();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        // Show loading indicator
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Processing image...'),
              duration: Duration(seconds: 1),
            ),
          );
        }

        // Try using Google ML Kit for better QR code detection
        final inputImage = mlkit.InputImage.fromFilePath(image.path);
        final barcodeScanner = mlkit.BarcodeScanner();
        
        try {
          final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(inputImage);
          
          if (barcodes.isNotEmpty) {
            final barcode = barcodes.first;
            if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
              await _onQRDetect(barcode.rawValue!);
            } else {
              _showErrorSnackBar('QR code detected but no data found');
            }
          } else {
            // Fallback to mobile_scanner if ML Kit doesn't find anything
            final result = await _controller.analyzeImage(image.path);
            if (result != null && result.barcodes.isNotEmpty) {
              final qrCode = result.barcodes.first.rawValue ?? 'Unknown QR';
              await _onQRDetect(qrCode);
            } else {
              _showErrorSnackBar('No QR code found in the image. Please try a different image.');
            }
          }
        } catch (e) {
          // Fallback to mobile_scanner if ML Kit fails
          final result = await _controller.analyzeImage(image.path);
          if (result != null && result.barcodes.isNotEmpty) {
            final qrCode = result.barcodes.first.rawValue ?? 'Unknown QR';
            await _onQRDetect(qrCode);
          } else {
            _showErrorSnackBar('Failed to process image. Please try again.');
          }
        } finally {
          barcodeScanner.close();
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await LoginService.logout();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RouteName.home);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 50), // Spacer for centering
                const Text(
                  'Scan QR Code',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black),
                  onPressed: _logout,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Place QR code inside the frame to scan\nAvoid shake to get result quickly',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: MobileScannerSimple(
                onDetect: _onQRDetect,
                controller: _controller,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Scanning Code...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bottomIcon('images/Flash_light.png', _toggleFlash),
                const SizedBox(width: 10),
                _bottomIcon('images/Gallary.png', _pickImageFromGallery),
              ],
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.results);
              },
              height: 60,
              minWidth: 370,
              color: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Place Camera Code',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        path,
        height: 25,
        width: 25,
      ),
    );
  }
}
