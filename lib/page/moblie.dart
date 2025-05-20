import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void mainmoblie() {
  runApp(
    const MaterialApp(title: 'Mobile Scanner Example', home: _ExampleHome()),
  );
}

/// Implementation of Mobile Scanner example with simple configuration
class MobileScannerSimple extends StatefulWidget {
  const MobileScannerSimple({super.key});

  @override
  State<MobileScannerSimple> createState() => _MobileScannerSimpleState();
}

class _MobileScannerSimpleState extends State<MobileScannerSimple> {
  Barcode? _barcode;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }
    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Mobile Scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _barcodePreview(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A more advanced scanner with flash and camera controls
class MobileScannerAdvanced extends StatefulWidget {
  const MobileScannerAdvanced({super.key});

  @override
  State<MobileScannerAdvanced> createState() => _MobileScannerAdvancedState();
}

class _MobileScannerAdvancedState extends State<MobileScannerAdvanced> {
  final MobileScannerController controller = MobileScannerController();
  Barcode? _barcode;

  void _handleDetection(BarcodeCapture barcodes) {
    if (barcodes.barcodes.isNotEmpty) {
      setState(() {
        _barcode = barcodes.barcodes.first;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Mobile Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller.switchCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleDetection,
          ),
          if (_barcode != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Scanned: ${_barcode!.displayValue ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Homepage with example selection
class _ExampleHome extends StatelessWidget {
  const _ExampleHome();

  Widget _buildItem(
    BuildContext context,
    String label,
    String subtitle,
    Widget page,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => page));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner Example'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            _buildItem(
              context,
              'Simple Mobile Scanner',
              'Quick scan without customization.',
              const MobileScannerSimple(),
              Icons.qr_code_scanner,
            ),
            _buildItem(
              context,
              'Advanced Mobile Scanner',
              'Scanner with camera and torch control.',
              const MobileScannerAdvanced(),
              Icons.settings_remote,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
