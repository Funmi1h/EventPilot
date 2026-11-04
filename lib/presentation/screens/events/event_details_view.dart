import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/data/models/event_model.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';
import 'package:eventpilot/presentation/screens/events/edit_event_view.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/section_header.dart';

class EventDetailsView extends StatefulWidget {
  final EventModel? event;
  final Map<String, dynamic>? eventData;

  const EventDetailsView({super.key, this.event, this.eventData});

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  //le controller pour manipuler l'evenement
  final EventController _controller = Get.isRegistered<EventController>()
      ? Get.find<EventController>()
      : Get.put(EventController());

  EventModel? _currentEvent;
  final String _publicLink = 'https://eventpilot.app/events/public';

  @override
  void initState() {
    super.initState();
    //on initialise l'evenement passe en parametre ou depuis les arguments
    if (widget.event != null) {
      _currentEvent = widget.event;
    } else if (Get.arguments is EventModel) {
      _currentEvent = Get.arguments as EventModel;
    } else if (_controller.selectedEvent.value != null) {
      _currentEvent = _controller.selectedEvent.value;
    } else if (_controller.events.isNotEmpty) {
      _currentEvent = _controller.events.first;
    }
  }

  //copier le lien public dans le presse papier
  void _copyPublicLink() {
    final link = _currentEvent?.computedPublicUrl ?? 'http://localhost:8080/#/public/event';
    Clipboard.setData(ClipboardData(text: link));
    Get.snackbar(
      'Lien copié',
      'Le lien public est dans votre presse-papiers.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
    );
  }

  //confirmer et supprimer l'evenement dans supabase
  void _confirmDelete() {
    Get.defaultDialog(
      title: 'Supprimer l\'événement ?',
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
      onConfirm: () async {
        Get.back();
        if (_currentEvent?.id != null) {
          await _controller.removeEvent(_currentEvent!.id!);
          Get.back(); //retourner a la liste
        }
      },
    );
  }

  //formater la date en francais
  String _formatDate(DateTime date) {
    const months = [
      '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  //separer les montants
  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentEvent == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Détails de l\'événement')),
        body: const Center(
          child: Text('Aucun événement trouvé'),
        ),
      );
    }

    final event = _currentEvent!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.back(),
        ),
        title: const Text('Détails de l\'événement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Modifier',
            onPressed: () async {
              final result = await Get.to(() => EditEventView(event: event));
              if (result == true) {
                //on rafraichit la vue locale
                setState(() {
                  _currentEvent = _controller.events.firstWhereOrNull(
                    (e) => e.id == event.id,
                  );
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
            const SectionLabel('Événement'),
            const SizedBox(height: 8),
            Text(
              event.name,
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
                  event.type,
                  dotColor: AppColors.accent,
                ),
                const SizedBox(width: 6),
                AppTag(
                  'Publiée',
                  dotColor: AppColors.success,
                ),
                const SizedBox(width: 6),
                AppTag(
                  event.isPaid
                      ? '${_formatAmount(event.ticketPrice)} FCFA'
                      : 'Entrée libre',
                  dotColor: event.isPaid ? AppColors.info : AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 22),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              '${_formatDate(event.date)} · ${event.time}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on_outlined,
              event.location.isNotEmpty ? event.location : 'Lieu non défini',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.account_balance_wallet_outlined,
              'Budget prévisionnel · ${_formatAmount(event.budget)} FCFA',
            ),
            if (event.description != null && event.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.notes_rounded,
                event.description!,
              ),
            ],
            const SizedBox(height: 28),

            _buildPublicationCard(),
            const SizedBox(height: 28),

            const SectionHeader(
              title: 'Pilotage',
              subtitle: 'Les outils de l\'événement',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildModuleCard(
                    title: 'Tableau de bord',
                    subtitle: 'Indicateurs clés',
                    icon: Icons.space_dashboard_outlined,
                    onTap: () {
                      _controller.selectEvent(event);
                      Get.toNamed(
                        AppRoutes.dashboardOrganizer,
                        arguments: event,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModuleCard(
                    title: 'Tâches',
                    subtitle: 'Gérer les tâches',
                    icon: Icons.checklist_outlined,
                    onTap: () => Get.toNamed(
                      AppRoutes.tasks,
                      arguments: event.id ?? '',
                    ),
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
                    subtitle: 'Suivi budgétaire',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () => Get.toNamed(
                      AppRoutes.expenses,
                      arguments: {
                        'eventId': event.id ?? '',
                        'budget': event.budget,
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildModuleCard(
                    title: 'Participants',
                    subtitle: 'Inscriptions',
                    icon: Icons.people_outline_rounded,
                    onTap: () => Get.toNamed(
                      AppRoutes.participants,
                      arguments: event.id ?? '',
                    ),
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
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPublicationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIconBox(icon: Icons.link_rounded),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Page publique',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pour les inscriptions et invitations',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                color: AppColors.accent,
                onPressed: _copyPublicLink,
              ),
            ],
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconBox(icon: icon),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
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
