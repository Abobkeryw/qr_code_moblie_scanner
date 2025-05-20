import 'package:flutter/material.dart';
import 'package:qr_code_andr/class/mobile_scanner_simple.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Scan QR Code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Place QR code inside the frame to scan\nAvoid shake to get result quickly',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Expanded(
                child: MobileScannerSimple(),
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
                _bottomIcon('images/Group 5.png', 'Image tapped!'),
                const SizedBox(width: 10),
                _bottomIcon('images/Flash_light.png', 'Flash tapped!'),
                const SizedBox(width: 10),
                _bottomIcon('images/Gallary.png', 'Gallery tapped!'),
              ],
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                print('Place Camera Code tapped!');
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
            // const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _bottomIcon(String path, String message) {
    return GestureDetector(
      onTap: () => print(message),
      child: Image.asset(
        path,
        height: 25,
        width: 25,
      ),
    );
  }
}
