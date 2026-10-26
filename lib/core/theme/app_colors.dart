import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Marque (jaune doré de la maquette)
  static const Color primary = Color(0xFFE8B432);
  static const Color primaryDark = Color(0xFFC8921A);
  static const Color primarySoft = Color(0xFFFDF3D6);
  static const Color onPrimary = Colors.white;

  // Accents
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentCoral = Color(0xFFFF8A5B);
  static const Color accentPurple = Color(0xFF4C3A8A);

  // Dégradé de l'écran d'accueil (01)
  static const LinearGradient welcomeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentOrange, accentCoral],
  );

  // Fonds
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);

  // Textes
  static const Color textPrimary = Color(0xFF1F2430);
  static const Color textSecondary = Color(0xFF6B7280);

  // États (statuts de tâches, paiements, alertes)
  static const Color success = Color(0xFF22A559);
  static const Color successSoft = Color(0xFFE6F6EC);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFE5484D);
  static const Color errorSoft = Color(0xFFFDECEC);
  static const Color info = Color(0xFF2563EB);
  static const Color infoSoft = Color(0xFFE8EFFD);
}