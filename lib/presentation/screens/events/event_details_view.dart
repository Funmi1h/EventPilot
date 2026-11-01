import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/screens/events/edit_event_view.dart';
import 'package:eventpilot/presentation/screens/home/dashboard_organizer.dart';
import 'package:eventpilot/presentation/screens/tasks/task_list_view.dart';
import 'package:eventpilot/presentation/screens/expenses/expense_list_view.dart';
import 'package:eventpilot/presentation/screens/participants/participants_list_view.dart';
import 'package:eventpilot/presentation/screens/public/public_event_view.dart';

class EventDetailsView extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventDetailsView({super.key, required this.eventData});

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  late bool _isPublished;
  late Map<String, dynamic> _event;
  final String _publicLink = 'https://eventpilot.app/e/m-rita-marc-2026';

  @override
  void initState() {
    super.initState();
    _event = Map<String, dynamic>.from(widget.eventData);
    _isPublished = _event['isPublished'] ?? true;
  }

  void _copyPublicLink() {
    Clipboard.setData(ClipboardData(text: _publicLink));
    Get.snackbar(
      'Lien copié',
      'Le lien public a été copié dans le presse-papiers.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.successSoft,
      colorText: AppColors.success,
      duration: const Duration(seconds: 2),
    );
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: 'Supprimer la cérémonie ?',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
      middleText: 'Cette action est irréversible. Toutes les tâches, dépenses et données associées seront supprimées.',
      textConfirm: 'Supprimer définitivement',
      textCancel: 'Conserver',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      cancelTextColor: AppColors.textSecondary,
      onConfirm: () {
        Get.back(); // close dialog
        Get.back(); // return to previous list
        Get.snackbar(
          'Supprimé',
          'La cérémonie a été supprimée avec succès.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSoft,
          colorText: AppColors.error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _event['title'] ?? 'Détails de l\'événement',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryDark),
            tooltip: 'Modifier',
            onPressed: () async {
              final result = await Get.to(() => EditEventView(eventData: _event));
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _event.addAll(result);
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            tooltip: 'Supprimer',
            onPressed: _confirmDelete,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── En-tête Cérémonie ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _event['type'] ?? 'Cérémonie',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isPublished ? AppColors.successSoft : AppColors.warningSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPublished ? Icons.check_circle : Icons.visibility_off,
                              size: 14,
                              color: _isPublished ? AppColors.success : AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isPublished ? 'Publiée' : 'Brouillon',
                              style: TextStyle(
                                color: _isPublished ? AppColors.success : AppColors.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _event['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.calendar_today_outlined, '${_event['date']} à ${_event['time']}'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on_outlined, _event['location'] ?? 'Cotonou, Bénin'),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.monetization_on_outlined,
                    _event['isPaid'] == true
                        ? 'Payant · ${_event['fee'] ?? "15 000 FCFA"}'
                        : 'Entrée gratuite (libre accès)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Contrôle de publication & Lien Public (3.2.8 & 3.2.9) ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visibilité de la page publique',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isPublished
                                ? 'La page est accessible par les participants'
                                : 'La page est masquée aux invités',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isPublished,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _isPublished = val);
                          Get.snackbar(
                            'Statut mis à jour',
                            val ? 'Page publique mise en ligne' : 'Page publique désactivée',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Lien public de la cérémonie',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _publicLink,
                            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: AppColors.primaryDark),
                          onPressed: _copyPublicLink,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Copier',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.to(() => const PublicEventView());
                    },
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Voir comme un participant'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Grille d'accès aux modules (Tableau de bord, Tâches, Dépenses, Participants) ──
            const Text(
              'Pilotage de la cérémonie',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildModuleCard(
                    title: 'Tableau de bord',
                    subtitle: 'Indicateurs clés',
                    icon: Icons.dashboard_customize_outlined,
                    color: AppColors.primary,
                    onTap: () {
                      Get.to(() => const DashboardScreen());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModuleCard(
                    title: 'Tâches',
                    subtitle: '${_event['tasksCompleted'] ?? 8}/${_event['tasksTotal'] ?? 14} faites',
                    icon: Icons.checklist_rounded,
                    color: AppColors.info,
                    onTap: () {
                      Get.to(() => const TaskListView());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildModuleCard(
                    title: 'Budget & Dépenses',
                    subtitle: 'Reste ${_event['budgetRestant'] ?? '700 000 F'}',
                    icon: Icons.account_balance_wallet_outlined,
                    color: AppColors.success,
                    onTap: () {
                      Get.to(() => const ExpenseListView());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModuleCard(
                    title: 'Participants',
                    subtitle: '${_event['participantsCount'] ?? 64} inscrits',
                    icon: Icons.people_outline_rounded,
                    color: AppColors.accentOrange,
                    onTap: () {
                      Get.to(() => const ParticipantsListView());
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
