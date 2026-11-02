import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';

class RegistrationSuccessView extends StatelessWidget {
  final String? participantName;
  final String? participantEmail;
  final String? eventTitle;
  final String? ticketCode;
  final bool isPaid;
  final String? amountPaid;

  const RegistrationSuccessView({
    super.key,
    this.participantName,
    this.participantEmail,
    this.eventTitle,
    this.ticketCode,
    this.isPaid = false,
    this.amountPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // ── Icône de succès animée ──
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.successSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Inscription confirmée ! 🎉',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isPaid
                    ? 'Votre paiement simulé de ${amountPaid ?? "15 000 FCFA"} a été validé avec succès.'
                    : 'Votre place est bien enregistrée pour la cérémonie.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // ── Billet numérique (Ticket pass) ──
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // En-tête billet
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.event_available, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'PASS INVITATION',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ticketCode ?? 'EP-DEMO-001',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Corps du billet
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventTitle ?? 'Mariage Rita & Marc',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Sam. 14 déc. 2026 · 15h00 · Hôtel du Lac, Cotonou',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Divider(height: 28),
                          _buildTicketInfo('Participant', participantName ?? 'Invité'),
                          const SizedBox(height: 8),
                          _buildTicketInfo('E-mail', participantEmail ?? '—'),
                          const SizedBox(height: 8),
                          _buildTicketInfo(
                            'Statut',
                            isPaid ? 'Payé & Confirmé' : 'Inscrit (Entrée libre)',
                            highlight: true,
                          ),
                          const SizedBox(height: 20),

                          // Simulation QR Code
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Icon(
                                    Icons.qr_code_2_rounded,
                                    size: 100,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Présentez ce QR Code à l\'accueil',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Boutons d'action ──
              AppButton(
                label: 'Enregistrer le pass',
                icon: Icons.download_rounded,
                onPressed: () {
                  Get.snackbar(
                    'Pass sauvegardé',
                    'Votre pass a été téléchargé dans vos documents.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.successSoft,
                    colorText: AppColors.success,
                  );
                },
              ),

              const SizedBox(height: 12),

              AppButton(
                label: 'Retour',
                type: AppButtonType.outlined,
                onPressed: () => Get.back(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: highlight ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
