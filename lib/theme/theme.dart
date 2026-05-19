import 'package:flutter/material.dart';

class YDYColors {
  static const Color black = Color(0xFF0C0C0C);
  static const Color dark = Color(0xFF141414);
  static const Color card = Color(0xFF1A1A1A);
  static const Color orange = Color(0xFFFF6B35);
  static const Color orangeDim = Color(0x22FF6B35);
  static const Color orangeGlow = Color(0x40FF6B35);
  static const Color teal = Color(0xFF4A7C7E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFAAAAAA);
  static const Color border = Color(0xFF252525);
  static const Color greyLight = Color(0xFF1E1E1E);
  static const Color green = Color(0xFF2ECC71);
  static const Color red = Color(0xFFE74C3C);
  static const Color blue = Color(0xFF6FA3EF);
  static const Color purple = Color(0xFFB482FF);
}

class YDYTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: YDYColors.black,
        colorScheme: const ColorScheme.dark(
          primary: YDYColors.orange,
          surface: YDYColors.card,
          background: YDYColors.black,
        ),
        textTheme: TextTheme(
          displayLarge: YDYTypography.bebasNeue(fontSize: 64),
          displayMedium: YDYTypography.bebasNeue(fontSize: 48),
          displaySmall: YDYTypography.bebasNeue(fontSize: 36),
          headlineMedium: YDYTypography.bebasNeue(fontSize: 28, letterSpacing: 0.5),
          bodyLarge: YDYTypography.dmSans(fontSize: 16, fontWeight: FontWeight.w300),
          bodyMedium: YDYTypography.dmSans(fontSize: 14, color: YDYColors.muted),
          labelLarge: YDYTypography.bebasNeue(fontSize: 18, letterSpacing: 1.5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: YDYColors.orange,
            foregroundColor: YDYColors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: YDYTypography.bebasNeue(fontSize: 18, letterSpacing: 1.5),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: YDYColors.muted,
            side: const BorderSide(color: YDYColors.border),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: YDYTypography.dmSans(fontSize: 13),
          ),
        ),
        cardTheme: CardThemeData(
          color: YDYColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: YDYColors.border, width: 1),
          ),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: YDYColors.greyLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: YDYColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: YDYColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: YDYColors.orange, width: 1.5),
          ),
          hintStyle: YDYTypography.dmSans(color: YDYColors.muted, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        dividerColor: YDYColors.border,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}

class YDYTextStyles {
  static final TextStyle title = YDYTypography.bebasNeue(
    fontSize: 46,
    letterSpacing: 1.2,
  );

  static final TextStyle body = YDYTypography.dmSans(
    fontSize: 15,
    color: YDYColors.muted,
    fontWeight: FontWeight.w300,
    height: 1.6,
  );

  static final TextStyle label = YDYTypography.dmSans(
    fontSize: 13,
    letterSpacing: 0.5,
  );

  static final TextStyle input = YDYTypography.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle hint = YDYTypography.dmSans(
    fontSize: 14,
    color: YDYColors.muted,
  );

  static final TextStyle error = YDYTypography.dmSans(
    fontSize: 12,
    color: YDYColors.red,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle link = YDYTypography.dmSans(
    fontSize: 13,
    color: YDYColors.orange,
    fontWeight: FontWeight.w500,
  );
}

class YDYTypography {
  static TextStyle bebasNeue({
    double? fontSize,
    Color color = YDYColors.white,
    double? letterSpacing,
    double? height,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        fontFamily: 'BebasNeue',
        fontSize: fontSize,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: fontWeight,
      );

  static TextStyle dmSans({
    double? fontSize,
    Color color = YDYColors.white,
    FontWeight? fontWeight,
    double? height,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: 'DMSans',
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      );
}
