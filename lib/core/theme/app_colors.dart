import 'package:flutter/material.dart';

/// Palette EventPilot — sobre, chaleureuse et lisible.
///
/// Le parti pris : un fond papier, une encre profonde pour les actions,
/// des bordures fines et un bronze discret comme seul accent de marque.
/// Les statuts ne sont jamais peints en aplats colorés : seule une
/// petite pastille porte la couleur.
class AppColors {
  AppColors._();

  // ── Marque ──
  static const Color primary = ink;
  static const Color primaryDark = ink;
  static const Color primarySoft = Color(0xFFFBE1CF);
  static const Color onPrimary = Colors.white;

  // ── Accents ──
  static const Color accent = Color(0xFFED7900);
  static const Color accentSoft = Color(0xFFFFF0E1);
  static const Color accentOrange = accent;
  static const Color accentCoral = Color(0xFFD8865D);
  static const Color accentPurple = Color(0xFFB76FA4);

  // Conservé pour compatibilité.
  static const LinearGradient welcomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4B2A17), Color(0xFF74401C)],
  );

  // ── Fonds ──
  static const Color frameBackground = Color(0xFFE9DADB);
  static const Color ink = Color(0xFF5D3216);
  static const Color inkSoft = Color(0xFF74401C);
  static const Color background = Color(0xFFF8F1EF);
  static const Color surface = Color(0xFFFFFBF9);
  static const Color surfaceMuted = Color(0xFFF4E9E5);
  static const Color border = Color(0xFFE9DCD7);
  static const Color borderStrong = Color(0xFFD8C8C1);

  // ── Textes ──
  static const Color textPrimary = Color(0xFF292423);
  static const Color textSecondary = Color(0xFF716762);
  static const Color textTertiary = Color(0xFF9D908A);

  // ── États ──
  static const Color success = Color(0xFF86A84D);
  static const Color successSoft = Color(0xFFEEF4D9);
  static const Color warning = Color(0xFFD77C19);
  static const Color warningSoft = Color(0xFFFFF1D8);
  static const Color error = Color(0xFFB84E45);
  static const Color errorSoft = Color(0xFFFCEAE6);
  static const Color info = Color(0xFF688B91);
  static const Color infoSoft = Color(0xFFE8F1F1);
}
