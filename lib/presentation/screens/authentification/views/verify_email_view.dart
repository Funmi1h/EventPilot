import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    //on recupere l'adresse email envoyee en argument
    final String email = Get.arguments is String ? (Get.arguments as String) : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.offAllNamed(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //icone de boite mail
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 34,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Vérifiez votre boîte mail',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.6,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  email.isNotEmpty
                      ? 'Un e-mail de confirmation a été envoyé à l\'adresse :\n$email\n\nVeuillez cliquer sur le lien qu\'il contient pour activer votre compte avant de vous connecter.'
                      : 'Un e-mail de confirmation vous a été envoyé. Veuillez cliquer sur le lien pour activer votre compte.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                //bouton pour aller a la page de connexion
                AppButton(
                  label: 'Retour à la connexion',
                  onPressed: () => Get.offAllNamed(AppRoutes.login),
                ),
                const SizedBox(height: 16),

                //aide en cas de non reception
                const Text(
                  'Vous ne trouvez pas l\'e-mail ? Pensez à vérifier vos spams ou courriers indésirables.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textTertiary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

