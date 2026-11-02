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
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/section_header.dart';

class EventDetailsView extends StatefulWidget {
  final Map<String, dynamic>? eventData;

  const EventDetailsView({super.key, this.eventData});

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

const _kDefaultEvent = {
  'id': '1',
  'title': 'Mariage Rita & Marc',
  'type': 'Mariage',
  'date': 'Sam. 14 déc. 2026',
  'time': '15h00',
  'location': 'Hôtel du Lac, Cotonou',
  'description': 'Une célébration réunissant famille et amis.',
  'progress': 0.72,
  'budgetInitial': '2 500 000 FCFA',
  'budgetRestant': '700 000 FCFA',
  'tasksTotal': 12,
  'tasksDone': 8,
  'participants': 64,
  'isPaid': true,
  'fee': '15 000 FCFA',
  'isPublished': true,
};

class _EventDetailsViewState extends State<EventDetailsView> {
  late bool _isPublished;
  late Map<String, dynamic> _event;
  final String _publicLink = 'https://eventpilot.app/e/m-rita-marc-2026';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    _event = Map<String, dynamic>.from(
      widget.eventData ?? args ?? _kDefaultEvent,
    );
    _isPublished = _event['isPublished'] ?? true;
  }

  void _copyPublicLink() {
    Clipboard.setData(ClipboardData(text: _publicLink));
    Get.snackbar(
      'Lien copié',
      'Le lien public est dans votre presse-papiers.',
    );
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: 'Supprimer la cérémonie ?',
      titleStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      middleText:
          'Cette action est irréversible. Les tâches, dépenses et données associées seront supprimées.',
      middleTextStyle: const TextStyle(
        fontSize: 13,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      textConfirm: 'Supprimer',
      textCancel: 'Conserver',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.ink,
      cancelTextColor: AppColors.textSecondary,
      onConfirm: () {
        Get.back();
        Get.back();
        Get.snackbar('Cérémonie supprimée', 'Les données ont été retirées.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.back(),
        ),
        title: const Text('Cérémonie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Modifier',
            onPressed: () async {
              final result =
                  await Get.to(() => EditEventView(eventData: _event));
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _event.addAll(result);
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            tooltip: 'Supprimer',
            onPressed: _confirmDelete,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('Cérémonie'),
            const SizedBox(height: 8),
            Text(
              _event['title'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.6,
                height: 1.25,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                AppTag(
                  _event['type'] ?? 'Cérémonie',
                  dotColor: AppColors.accent,
                ),
                const SizedBox(width: 6),
                AppTag(
                  _isPublished ? 'Publiée' : 'Brouillon',
                  dotColor:
                      _isPublished ? AppColors.success : AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 22),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              '${_event['date']} · ${_event['time']}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on_outlined,
              _event['location'] ?? 'Cotonou, Bénin',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.confirmation_number_outlined,
              _event['isPaid'] == true
                  ? 'Participation · ${_event['fee'] ?? "15 000 FCFA"}'
                  : 'Entrée libre',
            ),
            if ((_event['description'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.notes_rounded,
                _event['description'],
              ),
            ],
            const SizedBox(height: 28),

            _buildPublicationCard(),
            const SizedBox(height: 28),

            const SectionHeader(
              title: 'Pilotage',
              subtitle: 'Les outils de la cérémonie',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildModuleCard(
                    title: 'Tableau de bord',
                    subtitle: 'Indicateurs clés',
                    icon: Icons.space_dashboard_outlined,
                    onTap: () => Get.to(() => const DashboardScreen()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModuleCard(
                    title: 'Tâches',
                    subtitle:
                        '${_event['tasksDone'] ?? 8}/${_event['tasksTotal'] ?? 14} faites',
                    icon: Icons.checklist_outlined,
                    onTap: () => Get.to(() => const TaskListView()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildModuleCard(
                    title: 'Dépenses',
                    subtitle:
                        'Reste ${_event['budgetRestant'] ?? '700 000 FCFA'}',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () => Get.to(() => const ExpenseListView()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModuleCard(
                    title: 'Participants',
                    subtitle:
                        '${_event['participantsCount'] ?? _event['participants'] ?? 64} inscrits',
                    icon: Icons.people_outline_rounded,
                    onTap: () => Get.to(() => const ParticipantsListView()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublicationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Page publique',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _isPublished
                          ? 'Accessible aux participants'
                          : 'Masquée aux invités',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isPublished,
                onChanged: (val) {
                  setState(() => _isPublished = val);
                  Get.snackbar(
                    'Page publique',
                    val ? 'La page est en ligne.' : 'La page est masquée.',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          const Text(
            'Lien de partage',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(left: 13, right: 6, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _publicLink,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  color: AppColors.textSecondary,
                  onPressed: _copyPublicLink,
                  tooltip: 'Copier',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const PublicEventView()),
              child: const Text('Voir comme un participant'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconBox(icon: icon, size: 36, iconSize: 17, radius: 11),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
