import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_card.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
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

  void _openCreate() {
    Get.to(() => const CreateEventView());
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _selectedFilter == 'Toutes'
        ? _events
        : _events.where((e) => e['status'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cérémonies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            tooltip: 'Nouvelle cérémonie',
            onPressed: _openCreate,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
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
                        onTap: () =>
                            setState(() => _selectedFilter = filter),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: filteredEvents.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppCard(
                            title: event['title'],
                            subtitle:
                                '${event['date']} · ${event['time']}\n${event['location']}',
                            progress: event['progress'],
                            progressLabel:
                                '${event['tasksCompleted']}/${event['tasksTotal']} tâches faites',
                            badges: [
                              AppTag(
                                event['type'],
                                dotColor: AppColors.accent,
                              ),
                              AppTag(
                                event['isPublished']
                                    ? 'Page publiée'
                                    : 'Brouillon',
                                dotColor: event['isPublished']
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                              AppTag(
                                event['isPaid']
                                    ? event['fee']
                                    : 'Entrée libre',
                                dotColor: event['isPaid']
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
                              Get.to(() =>
                                  EventDetailsView(eventData: event));
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

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
              'Aucune cérémonie',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Vos cérémonies apparaîtront ici.',
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
