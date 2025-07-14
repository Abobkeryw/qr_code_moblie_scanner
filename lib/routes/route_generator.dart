import 'package:flutter/material.dart';
import 'route_name.dart';
import '../home.dart';
import '../page/onboarding_page.dart';
import '../page/qr_code.dart';
import '../page/result_page.dart';
import '../page/register_screen.dart';
import '../page/forgot_password.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Main routes
      case RouteName.onboarding:
        return MaterialPageRoute(builder: (context) => const OnboardingPage());
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const MyHomePage());
      case RouteName.login:
        return MaterialPageRoute(builder: (context) => const MyHomePage());
      
      // QR Scanner routes
      case RouteName.qrScanner:
        return MaterialPageRoute(builder: (context) => const QRCodePage());
      case RouteName.results:
        return MaterialPageRoute(builder: (context) => const ResultPage());
      
      // Authentication routes
      case RouteName.register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
      
      // Error route
      case RouteName.error:
        return MaterialPageRoute(builder: (context) => const PageNotFound());
      
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => const PageNotFound(),
    );
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '404',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Oops! Page Not Found',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The page you are looking for doesn\'t exist.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteName.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Go Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepOrange,
                      side: const BorderSide(color: Colors.deepOrange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 