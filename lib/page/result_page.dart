import 'package:flutter/material.dart';
import '../services/qr_code_service.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> qrCodes = [];
  Map<String, dynamic>? lastDeletedCode;
  int? lastDeletedIndex;
  final QrCodeService _qrCodeService = QrCodeService();

  @override
  void initState() {
    super.initState();
    loadSavedCodes();
  }

  Future<void> loadSavedCodes() async {
    final codes = await _qrCodeService.getAllQrCodes();
    setState(() {
      qrCodes = codes;
    });
  }

  Future<void> confirmDelete(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete QR Code?'),
        content: const Text('Are you sure you want to delete this QR code?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      lastDeletedCode = qrCodes[index];
      lastDeletedIndex = index;
      final qrCodeId = qrCodes[index]['id'] as int;

      setState(() {
        qrCodes.removeAt(index);
      });
      await _qrCodeService.deleteQrCode(qrCodeId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('QR Code deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              if (lastDeletedCode != null && lastDeletedIndex != null) {
                // Re-insert the QR code into the database
                await _qrCodeService.saveQrCode(lastDeletedCode!['value']);
                // Reload the list to get the updated data
                await loadSavedCodes();
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> confirmClearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All QR Codes?'),
        content: const Text('This will delete all saved QR codes. Proceed?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        qrCodes.clear();
      });
      await _qrCodeService.deleteAllQrCodes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All QR Codes cleared')),
      );
    }
  }

  String formatTimestamp(String timestamp) {
    final dt = DateTime.parse(timestamp);
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scanning Result',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Proreader will keep your last 10 days history\n'
                'To keep all your scanned history please\n'
                'purchase our pro package',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            if (qrCodes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: confirmClearAll,
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            Expanded(
              child: qrCodes.isEmpty
                  ? const Center(child: Text("No QR codes saved yet."))
                  : ListView.builder(
                      itemCount: qrCodes.length,
                      itemBuilder: (context, index) {
                        final code = qrCodes[index];
                        return Dismissible(
                          key: Key(code['value'] + code['timestamp']),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            await confirmDelete(index);
                            return false;
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.document_scanner, color: Colors.deepOrange),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          code['value'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formatTimestamp(code['timestamp']),
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => confirmDelete(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Send tapped");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
