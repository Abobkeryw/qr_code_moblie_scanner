import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_andr/routes/route_generator.dart';
import 'package:qr_code_andr/routes/route_name.dart';

void main() {
  group('Route Generator Tests', () {
    test('should generate route for onboarding', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: RouteName.onboarding),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate route for home', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: RouteName.home),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate route for QR scanner', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: RouteName.qrScanner),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate route for results', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: RouteName.results),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate route for register', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: RouteName.register),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate route for forgot password', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: RouteName.forgotPassword),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate error route for unknown route', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: '/unknown-route'),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate error route for null route', () {
      final route = RouteGenerator.generateRoute(
        RouteSettings(name: null),
      );
      expect(route, isA<MaterialPageRoute>());
    });
  });

  group('Route Name Constants Tests', () {
    test('should have correct route paths', () {
      expect(RouteName.onboarding, equals('/onboarding'));
      expect(RouteName.home, equals('/home'));
      expect(RouteName.login, equals('/login'));
      expect(RouteName.register, equals('/register'));
      expect(RouteName.qrScanner, equals('/qr-scanner'));
      expect(RouteName.results, equals('/results'));
      expect(RouteName.forgotPassword, equals('/forgot-password'));
      expect(RouteName.error, equals('/error'));
    });

    test('should have unique route paths', () {
      final routes = [
        RouteName.onboarding,
        RouteName.home,
        RouteName.login,
        RouteName.register,
        RouteName.qrScanner,
        RouteName.results,
        RouteName.forgotPassword,
        RouteName.error,
      ];
      
      final uniqueRoutes = routes.toSet();
      expect(uniqueRoutes.length, equals(routes.length));
    });
  });
} 