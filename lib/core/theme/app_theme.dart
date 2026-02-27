import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF0B1023);         // Bleu Nuit Profond (Primary Background - Dark)
  static const card = Color(0xFF131B36);       // Bleu Carte (Secondary Background - Dark)
  
  static const lightBg = Color(0xFFF1F5F9);    // Gris très clair (Background - Light)
  static const lightCard = Color(0xFFFFFFFF);  // Pure White (Card - Light)

  static const primary = Color(0xFF00E0FF);    // Cyan (Focus, Bordures, Titres)
  static const primaryVariant = Color(0xFF21C8FF); // Accent (Bleu)
  
  static const secondary = Color(0xFF00FF9A);  // Vert (Action Positive)
  static const secondaryVariant = Color(0xFF008F58); // Dégradé Vert fonce -> Vert
  
  static const gold = Color(0xFFFFD700);       // Gold (Premium, Légende)
  static const error = Color(0xFFEF4444);      // Rouge (Erreurs)
  
  static const muted = Color(0xFF94A3B8);      // Gris bleuté (Texte secondaire - Dark)
  static const lightMuted = Color(0xFF64748B); // Gris foncé (Texte secondaire - Light)
}

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.card,
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.chakraPetch(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.chakraPetch(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.chakraPetch(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.inter(color: Colors.white, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: AppColors.muted, fontSize: 14),
      labelLarge: GoogleFonts.chakraPetch(fontWeight: FontWeight.bold, letterSpacing: 1.2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.2), // Input sombre
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.error, width: 1)),
      labelStyle: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600),
      prefixIconColor: AppColors.muted,
      suffixIconColor: AppColors.muted,
    ),
    useMaterial3: true,
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightCard,
      error: AppColors.error,
      onSurface: Color(0xFF0F172A), // Text that sits on top of cards
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.chakraPetch(color: const Color(0xFF0F172A), fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.chakraPetch(color: const Color(0xFF0F172A), fontSize: 24, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.chakraPetch(color: const Color(0xFF0284C7), fontSize: 20, fontWeight: FontWeight.bold), // A slightly darker primary for light mode
      bodyLarge: GoogleFonts.inter(color: const Color(0xFF1E293B), fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: AppColors.lightMuted, fontSize: 14),
      labelLarge: GoogleFonts.chakraPetch(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.error, width: 1)),
      labelStyle: GoogleFonts.inter(color: const Color(0xFF0284C7), fontWeight: FontWeight.w600),
      prefixIconColor: AppColors.lightMuted,
      suffixIconColor: AppColors.lightMuted,
    ),
    useMaterial3: true,
  );
}
