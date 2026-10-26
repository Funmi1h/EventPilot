import 'package:flutter/material.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/views/auth/register_view.dart';
import 'package:eventpilot/views/auth/login_view.dart';
import 'package:eventpilot/views/shared/app_button.dart';
import 'package:eventpilot/views/shared/app_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.welcomeGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // ── Logo EventPilot ──
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.event,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'EventPilot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Carte événement (utilise AppCard) ──
                AppCard(
                  title: 'Mariage Rita & Marc',
                  subtitle: 'Sam. 14 déc. · 15h00',
                  progress: 0.97,
                  progressLabel: 'Préparatifs',
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  badges: [
                    AppCard.badge('8 tâches faites', AppColors.success),
                    AppCard.badge('64 inscrits', AppColors.info),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Badge budget ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.successSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      const SizedBox(width: 6),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Budget restant ',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            TextSpan(
                              text: '700 000 FCFA',
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── Titre principal ──
                const Text(
                  'Organisez vos\ncérémonies sans stress',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Sous-titre ──
                const Text(
                  'Tâches, budget, dépenses et participants réunis\ndans une seule application.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const Spacer(),

                // ── Bouton "Créer un compte" (utilise AppButton) ──
                AppButton(
                  label: 'Créer un compte',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // ── Bouton "Se connecter" (utilise AppButton outlined) ──
                AppButton(
                  label: 'Se connecter',
                  type: AppButtonType.outlined,
                  foregroundColor: Colors.white,
                  borderColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
