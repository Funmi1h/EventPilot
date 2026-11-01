import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_card.dart';
import 'package:eventpilot/presentation/screens/events/create_event_view.dart';
import 'package:eventpilot/presentation/screens/events/event_details_view.dart';

class EventsListView extends StatefulWidget {
  const EventsListView({super.key});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  String _selectedFilter = 'Toutes';
  final List<String> _filters = ['Toutes', 'À venir', 'Terminées'];

  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'Mariage Rita & Marc',
      'type': 'Mariage',
      'date': 'Sam. 14 déc. 2026',
      'time': '15h00',
      'location': 'Hôtel du Lac, Cotonou',
      'progress': 0.72,
      'progressLabel': 'Préparatifs avancés',
      'budgetInitial': '2 500 000 FCFA',
      'budgetRestant': '700 000 FCFA',
      'isPaid': true,
      'fee': '15 000 FCFA',
      'isPublished': true,
      'status': 'À venir',
      'tasksCompleted': 8,
      'tasksTotal': 14,
      'participantsCount': 64,
      'collected': '960 000 FCFA',
    },
    {
      'id': '2',
      'title': 'Baptême Lucas',
      'type': 'Baptême',
      'date': 'Dim. 25 janv. 2027',
      'time': '11h30',
      'location': 'Paroisse Saint-Michel, Cotonou',
      'progress': 0.35,
      'progressLabel': 'Planification initiale',
      'budgetInitial': '1 200 000 FCFA',
      'budgetRestant': '950 000 FCFA',
      'isPaid': false,
      'fee': 'Gratuit',
      'isPublished': true,
      'status': 'À venir',
      'tasksCompleted': 3,
      'tasksTotal': 9,
      'participantsCount': 42,
      'collected': '0 FCFA',
    },
    {
      'id': '3',
      'title': 'Gala Promotion IFRI GL3',
      'type': 'Soirée',
      'date': 'Ven. 30 oct. 2026',
      'time': '20h00',
      'location': 'Palais des Congrès, Cotonou',
      'progress': 1.0,
      'progressLabel': 'Événement clôturé',
      'budgetInitial': '3 000 000 FCFA',
      'budgetRestant': '120 000 FCFA',
      'isPaid': true,
      'fee': '10 000 FCFA',
      'isPublished': false,
      'status': 'Terminées',
      'tasksCompleted': 18,
      'tasksTotal': 18,
      'participantsCount': 120,
      'collected': '1 200 000 FCFA',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _selectedFilter == 'Toutes'
        ? _events
        : _events.where((e) => e['status'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mes Cérémonies',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 26),
            tooltip: 'Nouvelle cérémonie',
            onPressed: () {
              Get.to(() => const CreateEventView());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Filtres de statut ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: const Color(0xFFF3F4F6),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedFilter = filter);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // ── Liste des cartes événements ──
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          const Text(
                            'Aucune cérémonie trouvée',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: AppCard(
                            title: event['title'],
                            subtitle: '${event['date']} · ${event['time']} · ${event['location']}',
                            progress: event['progress'],
                            progressLabel: '${event['tasksCompleted']}/${event['tasksTotal']} tâches faites',
                            badges: [
                              AppCard.badge(event['type'], AppColors.primary),
                              if (event['isPublished'])
                                AppCard.badge('Page publiée', AppColors.success)
                              else
                                AppCard.badge('Brouillon', AppColors.warning),
                              if (event['isPaid'])
                                AppCard.badge('${event['fee']}', AppColors.info)
                              else
                                AppCard.badge('Entrée libre', AppColors.success),
                            ],
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            onTap: () {
                              Get.to(() => EventDetailsView(eventData: event));
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const CreateEventView());
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Créer un événement',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
