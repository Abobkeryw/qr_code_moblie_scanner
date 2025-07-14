import '../database/database_helper.dart';

class QrCodeService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Save a new QR code to the database
  Future<int> saveQrCode(String value) async {
    final timestamp = DateTime.now().toIso8601String();
    return await _databaseHelper.insertQrCode(value, timestamp);
  }

  // Get all saved QR codes
  Future<List<Map<String, dynamic>>> getAllQrCodes() async {
    return await _databaseHelper.getAllQrCodes();
  }

  // Delete a QR code by ID
  Future<int> deleteQrCode(int id) async {
    return await _databaseHelper.deleteQrCode(id);
  }

  // Delete all QR codes
  Future<int> deleteAllQrCodes() async {
    return await _databaseHelper.deleteAllQrCodes();
  }
} 