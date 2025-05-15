import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_go/app/core/theme/app_theme.dart';
import 'package:store_go/app/core/theme/ui_config.dart';

void main() {
  group('AppTheme Tests', () {
    test('Light theme creation', () {
      final theme = AppTheme.light();
      
      expect(theme, isA<ThemeData>());
      expect(theme.brightness, equals(Brightness.light));
      expect(theme.scaffoldBackgroundColor, equals(const Color(0xFFFFFFFF)));
      expect(theme.primaryColor, equals(const Color(0xFF000000)));
    });

    test('Dark theme creation', () {
      final theme = AppTheme.dark();
      
      expect(theme, isA<ThemeData>());
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.scaffoldBackgroundColor, equals(const Color(0xFF121212)));
      expect(theme.primaryColor, equals(const Color(0xFFFFFFFF)));
    });

    group('Color Scheme Tests', () {
      test('Light theme color scheme', () {
        final theme = AppTheme.light();
        final colorScheme = theme.colorScheme;

        expect(colorScheme.primary, equals(const Color(0xFF000000)));
        expect(colorScheme.secondary, equals(const Color(0xFFF5F5F5)));
        expect(colorScheme.error, equals(const Color(0xFFFF0000)));
        expect(colorScheme.brightness, equals(Brightness.light));
      });

      test('Dark theme color scheme', () {
        final theme = AppTheme.dark();
        final colorScheme = theme.colorScheme;

        expect(colorScheme.primary, equals(const Color(0xFFFFFFFF)));
        expect(colorScheme.secondary, equals(const Color(0xFF2A2A2A)));
        expect(colorScheme.error, equals(const Color(0xFFff1a1a)));
        expect(colorScheme.brightness, equals(Brightness.dark));
      });
    });

    group('Text Theme Tests', () {
      test('Light theme text styles', () {
        final theme = AppTheme.light();
        final textTheme = theme.textTheme;

        expect(textTheme.bodyLarge?.color, equals(const Color(0xFF000000)));
        expect(textTheme.bodyLarge?.fontSize, equals(UIConfig.fontSizeMedium));
        expect(textTheme.bodyLarge?.fontFamily, equals('Poppins'));
      });

      test('Dark theme text styles', () {
        final theme = AppTheme.dark();
        final textTheme = theme.textTheme;

        expect(textTheme.bodyLarge?.color, equals(const Color(0xFFFFFFFF)));
        expect(textTheme.bodyLarge?.fontSize, equals(UIConfig.fontSizeMedium));
        expect(textTheme.bodyLarge?.fontFamily, equals('Poppins'));
      });
    });

    group('Input Decoration Theme Tests', () {
      test('Light theme input decoration', () {
        final theme = AppTheme.light();
        final inputTheme = theme.inputDecorationTheme;

        expect(inputTheme.filled, isTrue);
        expect(inputTheme.fillColor, equals(const Color(0xFFF4F4F4)));
        expect(inputTheme.border, isA<OutlineInputBorder>());
      });

      test('Dark theme input decoration', () {
        final theme = AppTheme.dark();
        final inputTheme = theme.inputDecorationTheme;

        expect(inputTheme.filled, isTrue);
        expect(inputTheme.fillColor, equals(const Color(0xFF202020)));
        expect(inputTheme.border, isA<OutlineInputBorder>());
      });
    });

    group('Button Theme Tests', () {
      test('Light theme button styles', () {
        final theme = AppTheme.light();
        
        expect(theme.elevatedButtonTheme, isNotNull);
        expect(theme.textButtonTheme, isNotNull);
        expect(theme.outlinedButtonTheme, isNotNull);
      });

      test('Dark theme button styles', () {
        final theme = AppTheme.dark();
        
        expect(theme.elevatedButtonTheme, isNotNull);
        expect(theme.textButtonTheme, isNotNull);
        expect(theme.outlinedButtonTheme, isNotNull);
      });
    });
  });
}