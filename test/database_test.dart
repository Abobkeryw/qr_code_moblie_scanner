import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_andr/database/database_helper.dart';

void main() {
  group('DatabaseHelper Tests', () {
    late DatabaseHelper databaseHelper;

    setUp(() {
      databaseHelper = DatabaseHelper();
    });

    test('should insert and retrieve QR code', () async {
      // Insert a test QR code
      final id = await databaseHelper.insertQrCode('test_qr_code', '2024-01-01T12:00:00.000Z');
      expect(id, isA<int>());
      expect(id, greaterThan(0));

      // Retrieve all QR codes
      final codes = await databaseHelper.getAllQrCodes();
      expect(codes, isNotEmpty);
      
      // Check if our test code is in the list
      final testCode = codes.firstWhere((code) => code['value'] == 'test_qr_code');
      expect(testCode['value'], equals('test_qr_code'));
      expect(testCode['timestamp'], equals('2024-01-01T12:00:00.000Z'));
    });

    test('should delete QR code by ID', () async {
      // Insert a test QR code
      final id = await databaseHelper.insertQrCode('test_delete', '2024-01-01T12:00:00.000Z');
      
      // Delete the QR code
      final deletedRows = await databaseHelper.deleteQrCode(id);
      expect(deletedRows, equals(1));
      
      // Verify it's deleted
      final codes = await databaseHelper.getAllQrCodes();
      final deletedCode = codes.where((code) => code['id'] == id).toList();
      expect(deletedCode, isEmpty);
    });

    test('should delete all QR codes', () async {
      // Insert multiple test QR codes
      await databaseHelper.insertQrCode('test1', '2024-01-01T12:00:00.000Z');
      await databaseHelper.insertQrCode('test2', '2024-01-01T12:00:00.000Z');
      
      // Delete all QR codes
      final deletedRows = await databaseHelper.deleteAllQrCodes();
      expect(deletedRows, greaterThan(0));
      
      // Verify all are deleted
      final codes = await databaseHelper.getAllQrCodes();
      expect(codes, isEmpty);
    });
  });
} 