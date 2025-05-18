# Language-Specific Font Support

This guide explains how to use language-specific fonts in the Fashion Template app.

## Overview

The app now supports different fonts for different languages. Currently:

- English and French use "Poppins" as the default font
- Arabic uses "NotoKufiArabic" for better Arabic character rendering

## How to Apply Language-Specific Fonts

There are several ways to apply language-specific fonts to your text:

### Option 1: Using LocalizationService Directly

```dart
Text(
  'Your text here',
  style: LocalizationService.getLocalizedTextStyle(
    context,
    const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  ),
),
```

### Option 2: Using LanguageFontUtility Directly

```dart
Text(
  'Your text here',
  style: LanguageFontUtility.getTextStyle(
    context: context,
    baseStyle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  ),
),
```

### Option 3: For Custom TextStyles

```dart
final myStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
final localizedStyle = LocalizationService.getLocalizedTextStyle(context, myStyle);

Text('Your text', style: localizedStyle);
```

## Testing Languages

You can test different languages by:

1. Going to the Language selection screen
2. Selecting a different language (Arabic to test NotoKufiArabic)
3. Check how text renders in different parts of the app

## Adding Support for More Languages

To add support for more languages and their specific fonts:

1. Add the font files to `assets/fonts/YourFontName/`
2. Register the font in `pubspec.yaml`
3. Update `LanguageFontUtility.getFontFamilyForLanguage()` method to return the appropriate font for the language code
