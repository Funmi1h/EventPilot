import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/data/models/event_model.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';
import 'package:eventpilot/presentation/screens/events/create_event_view.dart';
import 'package:eventpilot/presentation/screens/events/event_details_view.dart';
import 'package:eventpilot/presentation/widgets/app_card.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';

class EventsListView extends StatefulWidget {
  const EventsListView({super.key});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  //on recupere ou on instancie le controller des evenements
  final EventController _controller = Get.put(EventController());
  String _selectedFilter = 'Toutes';
  final List<String> _filters = ['Toutes', 'À venir', 'Terminées'];

  @override
  void initState() {
    super.initState();
    //on force le chargement des evenements a l'ouverture de l'ecran
    _controller.fetchEvents();
  }

  //ouvrir l'ecran de creation puis recharger la liste
  void _openCreate() {
    Get.to(() => const CreateEventView())?.then((_) {
      _controller.fetchEvents();
    });
  }

  //formater la date en francais
  String _formatDate(DateTime date) {
    const months = [
      '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  //separer les montants par des espaces
  String _formatBudget(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Événements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            tooltip: 'Nouvel événement',
            onPressed: _openCreate,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            //barre de filtres horizontaux
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
                child: Row(
                  children: _filters.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: AppFilterChip(
                        label: filter,
                        selected: _selectedFilter == filter,
                        onTap: () => setState(() => _selectedFilter = filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            //la liste reactive des evenements
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.ink),
                  );
                }

                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);

                //filtrer les evenements selon le choix
                final filteredEvents = _controller.events.where((e) {
                  if (_selectedFilter == 'À venir') {
                    return !e.date.isBefore(today);
                  }
                  if (_selectedFilter == 'Terminées') {
                    return e.date.isBefore(today);
                  }
                  return true;
                }).toList();

                //afficher l'ecran vide si aucun evenement
                if (filteredEvents.isEmpty) {
                  return _buildEmptyState();
                }

                //glisser vers le bas pour rafraichir
                return RefreshIndicator(
                  color: AppColors.ink,
                  onRefresh: () => _controller.fetchEvents(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      final isUpcoming = !event.date.isBefore(today);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          title: event.name,
                          subtitle:
                              '${_formatDate(event.date)} · ${event.time}\n${event.location.isNotEmpty ? event.location : 'Lieu non défini'}',
                          badges: [
                            AppTag(
                              event.type,
                              dotColor: AppColors.accent,
                            ),
                            AppTag(
                              isUpcoming ? 'À venir' : 'Terminée',
                              dotColor: isUpcoming
                                  ? AppColors.success
                                  : AppColors.textTertiary,
                            ),
                            AppTag(
                              event.isPaid
                                  ? '${_formatBudget(event.ticketPrice)} FCFA'
                                  : 'Entrée libre',
                              dotColor: event.isPaid
                                  ? AppColors.info
                                  : AppColors.success,
                            ),
                          ],
                          trailing: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 17,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () {
                            _controller.selectEvent(event);
                            //ouvrir les details de l'evenement
                            Get.to(() => EventDetailsView(event: event));
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //vue affichee quand la liste est vide
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.event_outlined,
                size: 22,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun événement',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Créez votre premier événement pour commencer la planification.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Créer un événement',
              onPressed: _openCreate,
            ),
          ],
        ),
      ),
    );
  }
}
