import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/screens/tasks/create_task_view.dart';
import 'package:eventpilot/presentation/widgets/section_header.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  String _selectedFilter = 'Toutes';

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Réserver la salle de réception',
      'subtitle': 'Hôtel du Lac — acompte versé',
      'deadline': '15 oct.',
      'status': 'Terminée',
      'completed': true,
      'overdue': false,
    },
    {
      'title': 'Confirmer le traiteur',
      'subtitle': 'Valider le menu et le nombre de couverts',
      'deadline': '18 oct.',
      'status': 'En retard',
      'completed': false,
      'overdue': true,
    },
    {
      'title': 'Commander la décoration florale',
      'subtitle': 'Thème blanc et doré',
      'deadline': '05 nov.',
      'status': 'En cours',
      'completed': false,
      'overdue': false,
    },
    {
      'title': 'Envoyer les invitations',
      'subtitle': 'Liste de 120 invités',
      'deadline': '10 nov.',
      'status': 'À faire',
      'completed': false,
      'overdue': false,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    switch (_selectedFilter) {
      case 'À faire':
        return _tasks.where((t) => t['status'] == 'À faire').toList();
      case 'En cours':
        return _tasks.where((t) => t['status'] == 'En cours').toList();
      case 'Terminées':
        return _tasks.where((t) => t['completed'] == true).toList();
      case 'En retard':
        return _tasks.where((t) => t['overdue'] == true).toList();
      default:
        return _tasks;
    }
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];
      task['completed'] = !(task['completed'] as bool);
      if (task['completed'] as bool) {
        task['status'] = 'Terminée';
        task['overdue'] = false;
      } else {
        task['status'] = 'À faire';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filters = ['Toutes', 'À faire', 'En cours', 'En retard', 'Terminées'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.back(),
        ),
        title: const Text('Tâches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            tooltip: 'Nouvelle tâche',
            onPressed: () => Get.to(() => const CreateTaskView()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          children: [
            _buildProgressCard(),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
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
            const SizedBox(height: 16),
            if (_filtered.isEmpty)
              _buildEmptyState()
            else
              ...List<Widget>.generate(_filtered.length, (index) {
                final task = _filtered[index];
                final realIndex = _tasks.indexOf(task);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildTaskCard(task, realIndex),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Progression'),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '8',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                  height: 1,
                  color: AppColors.textPrimary,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: Text(
                  '  sur 14 tâches',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.57,
              minHeight: 5,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.ink),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '57 % des préparatifs terminés',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    final bool completed = task['completed'] as bool;
    final bool overdue = task['overdue'] as bool;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _toggleTask(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completed ? AppColors.ink : Colors.transparent,
                    border: Border.all(
                      color: completed
                          ? AppColors.ink
                          : (overdue ? AppColors.error : AppColors.borderStrong),
                      width: 1.3,
                    ),
                  ),
                  child: completed
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: completed
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        decoration:
                            completed ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task['subtitle'],
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 13,
                    color: overdue
                        ? AppColors.error
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Échéance ${task['deadline']}',
                    style: TextStyle(
                      fontSize: 11,
                      color: overdue
                          ? AppColors.error
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              AppTag(
                task['status'],
                dotColor: _statusColor(task['status']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Terminée':
        return AppColors.success;
      case 'En retard':
        return AppColors.error;
      case 'En cours':
        return AppColors.accent;
      default:
        return AppColors.textTertiary;
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.checklist_rounded,
              size: 21,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Aucune tâche ici',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Changez de filtre ou ajoutez une tâche.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Alias de compatibilité
typedef TasksView = TaskListView;
