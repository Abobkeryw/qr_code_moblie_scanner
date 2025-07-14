import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_code_andr/firebase_options.dart';
import 'package:qr_code_andr/routes/route_generator.dart';
import 'package:qr_code_andr/routes/route_name.dart';
import 'package:qr_code_andr/services/login_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
     const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingWrapper(),
    );
  }
}

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({Key? key}) : super(key: key);

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  bool _isLoading = true;
  bool _showOnboarding = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    final isLoggedIn = await LoginService.isLoggedIn();
    
    setState(() {
      _showOnboarding = !onboardingCompleted;
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.deepOrange,
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: _getInitialRoute(),
    );
  }

  String _getInitialRoute() {
    if (_showOnboarding) {
      return RouteName.onboarding;
    } else if (_isLoggedIn) {
      return RouteName.qrScanner;
    } else {
      return RouteName.home;
    }
  }
}
