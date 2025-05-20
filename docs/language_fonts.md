# Language-Specific Font Support

This guide explains how to use language-specific fonts in the Fashion Template app.

## Overview

The app now supports different fonts for different languages. Currently:

- English and French use "Poppins" as the default font
- Arabic uses "NotoKufiArabic" for better Arabic character rendering and display

## Implementation

The language-specific font support is implemented through several components:

1. **Font Registration**: NotoKufiArabic font is registered in `pubspec.yaml` with all necessary weights
2. **Language Font Utility**: The `LanguageFontUtility` class selects fonts based on the language code
3. **Extension Integration**: All built-in text styles use `LocalizationService.applyArabicFontIfNeeded()` to apply Arabic fonts automatically
4. **Centralized Configuration**: Font family constants are defined in `AppTypography` class

## How to Apply Language-Specific Fonts

After our latest updates, Arabic fonts are applied automatically for all text in the app through the text extension system. There are two main ways to apply language-specific fonts:

### Option 1: Using Text Extensions (RECOMMENDED)

```dart
// The heading2, body, caption, etc. extensions will automatically apply
// Arabic fonts when the app language is set to Arabic
Text('auth.welcome'.translate()).heading2(context)
```

### Option 2: Using LocalizationService Directly

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

### Option 3: Using LanguageFontUtility Directly

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

### For Custom TextStyles

```dart
final myStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
final localizedStyle = LocalizationService.applyArabicFontIfNeeded(context, myStyle);
```

## Best Practices

1. **Use Text Extensions**: Whenever possible, use the text extensions (heading1, body, etc.) as they automatically handle language-specific fonts.

2. **Always Use Translation Keys**: Use translation keys with the `translate()` extension method instead of hardcoding text:

   ```dart
   // Good
   Text('auth.welcome'.translate()).heading2(context)

   // Avoid
   Text('Welcome').heading2(context)
   ```

3. **Consider Text Direction**: Use LocalizationService's alignment helpers for proper RTL/LTR support:

   ```dart
   alignment: LocalizationService.getStartAlignment(context)
   ```

4. **Form Field Labels**: For form fields, use the translation extension with LocalizationService:
   ```dart
   "auth.email".translate().emailField(
     context,
     fieldState: controller.emailFieldState,
   )
   ```

## Testing

Always test your UI in multiple languages, especially Arabic, to ensure:

1. Text is not cut off
2. Layout adapts properly to RTL
3. Arabic characters render correctly with NotoKufiArabic
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
```
