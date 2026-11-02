import 'package:flutter/material.dart';
import 'package:eventpilot/core/theme/app_colors.dart';

/// Types de boutons disponibles dans l'application.
enum AppButtonType {
  /// Bouton plein (encre) — action principale.
  primary,

  /// Bouton avec bordure fine — action secondaire.
  outlined,

  /// Bouton texte — action tertiaire.
  text,
}

/// Bouton réutilisable, sobre et cohérent.
///
/// Pas d'ombre, pas de dégradé : une forme simple, une seule couleur forte.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.height = 54,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
            ),
          )
        : _buildLabel();

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.ink,
            foregroundColor: foregroundColor ?? Colors.white,
            disabledBackgroundColor:
                (backgroundColor ?? AppColors.ink).withValues(alpha: 0.35),
            disabledForegroundColor: Colors.white70,
            elevation: 0,
            shadowColor: Colors.transparent,
            minimumSize: Size(0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          child: child,
        );
        break;

      case AppButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.surface,
            foregroundColor: foregroundColor ?? AppColors.textPrimary,
            side: BorderSide(
              color: borderColor ?? AppColors.borderStrong,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            minimumSize: Size(0, height),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
          child: child,
        );
        break;

      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColors.textSecondary,
            textStyle: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: child,
        );
        break;
    }

    return fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Color get _foregroundColor {
    if (foregroundColor != null) return foregroundColor!;
    switch (type) {
      case AppButtonType.primary:
        return Colors.white;
      case AppButtonType.outlined:
      case AppButtonType.text:
        return AppColors.textPrimary;
    }
  }

  Widget _buildLabel() {
    if (icon == null) {
      return Text(label);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 9),
        Text(label),
      ],
    );
  }
}
