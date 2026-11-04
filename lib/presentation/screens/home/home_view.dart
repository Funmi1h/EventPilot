import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';

/// Écran d'entrée.
///
/// Un seul propos : se connecter ou créer un compte. Aucun aperçu
/// d'événement, aucune décoration inutile — juste la marque, une phrase
/// et deux chemins clairs.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrand(),
                        const SizedBox(height: 84),
                        _buildHero(),
                        const SizedBox(height: 40),
                        _buildActions(),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.ink, width: 1.2),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.ink,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EventPilot',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 1),
            Text(
              'ORGANISATION D\'ÉVÉNEMENTS',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'L\'ESSENTIEL, AU MÊME ENDROIT',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.3,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Organisez vos\nmoments importants.\nSereinement.',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.15,
            height: 1.16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Tâches, budget, invités et paiements réunis dans un seul espace — '
          'pour garder l\'esprit libre le jour J.',
          style: TextStyle(
            fontSize: 14.5,
            height: 1.65,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        AppButton(
          label: 'Créer un compte',
          onPressed: () => Get.toNamed(AppRoutes.register),
        ),
        const SizedBox(height: 10),
        AppButton(
          label: 'Se connecter',
          type: AppButtonType.outlined,
          onPressed: () => Get.toNamed(AppRoutes.login),
        ),
      ],
    );
  }
}
