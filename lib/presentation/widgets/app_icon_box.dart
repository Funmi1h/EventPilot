import 'package:flutter/material.dart';
import 'package:eventpilot/core/theme/app_colors.dart';

/// Carré d'icône neutre, réutilisé dans les listes et les cartes.
class AppIconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? background;
  final Color? color;
  final double radius;

  const AppIconBox({
    super.key,
    required this.icon,
    this.size = 42,
    this.iconSize = 19,
    this.background,
    this.color,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: color ?? AppColors.textSecondary,
      ),
    );
  }
}
