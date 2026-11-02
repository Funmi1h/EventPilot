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
  // L'encre remplace l'ancien jaune doré : plus calme, plus humain.
  static const Color primary = ink;
  static const Color primaryDark = ink;
  static const Color primarySoft = Color(0xFFF2EEE6);
  static const Color onPrimary = Colors.white;

  // ── Accents ──
  static const Color accent = Color(0xFF8C7351); // bronze
  static const Color accentSoft = Color(0xFFF6F1E8);
  static const Color accentOrange = accent;
  static const Color accentCoral = Color(0xFFA98763);
  static const Color accentPurple = Color(0xFF6E6558);

  // Conservé pour compatibilité : un dégradé encre, jamais criard.
  static const LinearGradient welcomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF211F1B), Color(0xFF3A362F)],
  );

  // ── Fonds ──
  static const Color ink = Color(0xFF1B1A17);
  static const Color inkSoft = Color(0xFF2C2A25);
  static const Color background = Color(0xFFFAF9F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF4F1EB);
  static const Color border = Color(0xFFE8E3DA);
  static const Color borderStrong = Color(0xFFD7D0C3);

  // ── Textes ──
  static const Color textPrimary = Color(0xFF1B1A17);
  static const Color textSecondary = Color(0xFF6B675E);
  static const Color textTertiary = Color(0xFF9B958A);

  // ── États ──
  static const Color success = Color(0xFF3F6B4F);
  static const Color successSoft = Color(0xFFEDF3EE);
  static const Color warning = Color(0xFF946B33);
  static const Color warningSoft = Color(0xFFF7F0E4);
  static const Color error = Color(0xFF9B4A40);
  static const Color errorSoft = Color(0xFFF8EEEC);
  static const Color info = Color(0xFF3E5C76);
  static const Color infoSoft = Color(0xFFEDF1F5);
}
