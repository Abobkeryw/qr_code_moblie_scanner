import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_andr/home.dart';
import 'package:qr_code_andr/page/moblie.dart';
import 'package:qr_code_andr/page/qr_code.dart';
import '/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Top Background Image',
      debugShowCheckedModeBanner: false,
      home: QRCodePage(),
    );
  }
}