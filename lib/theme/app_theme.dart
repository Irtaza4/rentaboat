import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand & Palette Colors
  static const Color primaryBlue = Color(0xFF0512DD);
  static const Color electricBlue = Color(0xFF2B4FE8);
  static const Color lightBlue = Color(0xFFB4D6FA);
  static const Color softPink = Color(0xFFFFA4C8);
  static const Color mintGreen = Color(0xFF48D1B6);
  static const Color coralRed = Color(0xFFFA5463);
  static const Color darkBlue = Color(0xFF0D1B5E);

  // Neutral Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surfaceOffWhite = Color(0xFFF7F8FA);
  static const Color searchPillBg = Color(0xFFF4F6F9);
  static const Color textDark = Color(0xFF1E2229);
  static const Color textGray = Color(0xFF6B7580);
  static const Color textLightGray = Color(0xFF9AA4AF);
  static const Color dividerColor = Color(0xFFEBEFF4);

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0A1E50).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: const Color(0xFF0A1E50).withValues(alpha: 0.14),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> softGlow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ThemeData
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.outfitTextTheme().apply(
      bodyColor: textDark,
      displayColor: textDark,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: softPink,
        surface: background,
        error: coralRed,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textGray,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
