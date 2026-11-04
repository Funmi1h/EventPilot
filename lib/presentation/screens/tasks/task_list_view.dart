import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/data/models/task_model.dart';
import 'package:eventpilot/presentation/screens/tasks/controller/task_controller.dart';
import 'package:eventpilot/presentation/screens/tasks/create_task_view.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  //recuperer ou instancier le controller des taches
  final TaskListController _controller = Get.put(TaskListController());

  @override
  void initState() {
    super.initState();
    //charger les taches de l'evenement courant
    final eventId = Get.arguments is String ? (Get.arguments as String) : null;
    _controller.initTasks(eventId);
  }

  //ouvrir l'ecran de creation d'une tache
  void _openCreateTask() {
    Get.to(
      () => const CreateTaskView(),
      arguments: _controller.currentEventId.value,
    )?.then((_) {
      _controller.initTasks(_controller.currentEventId.value);
    });
  }

  //formater la date limite en francais
  String _formatDueDate(DateTime date) {
    const months = [
      '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month]}';
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
        title: const Text('Tâches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            tooltip: 'Nouvelle tâche',
            onPressed: _openCreateTask,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            //en tete resumant la progression
            _buildProgressSummary(),

            //barre horizontale des filtres
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
                child: Obx(
                  () => Row(
                    children: _controller.filters.map((filter) {
                      final isSelected = _controller.selectedFilter.value == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: AppFilterChip(
                          label: filter,
                          selected: isSelected,
                          onTap: () => _controller.changeFilter(filter),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            //liste reactive des taches
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.ink),
                  );
                }

                final tasks = _controller.filteredTasks;

                if (tasks.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  color: AppColors.ink,
                  onRefresh: () => _controller.fetchTasks(_controller.currentEventId.value),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _buildTaskCard(task);
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

  //resume de la progression
  Widget _buildProgressSummary() {
    return Obx(() {
      final total = _controller.tasks.length;
      final done = _controller.completedCount;
      final percent = _controller.progressPercentage;
      final ratio = _controller.progressRatio;

      return Container(
        margin: const EdgeInsets.fromLTRB(22, 6, 22, 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  total == 0
                      ? 'Aucune tâche'
                      : '$done sur $total tâche${total > 1 ? 's' : ''} terminée${done > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$percent %',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 5,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
            ),
          ],
        ),
      );
    });
  }

  //boite de dialogue pour modifier une tache
  void _showEditTaskDialog(TaskModel task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description ?? '');
    DateTime selectedDate = task.dueDate;
    String selectedStatus = task.status;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit_note_rounded,
                                  color: AppColors.ink,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Modifier la tâche',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            color: AppColors.textTertiary,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      AppTextField(
                        label: 'Nom de la tâche',
                        controller: titleController,
                        hintText: 'Ex. Confirmer le traiteur',
                        isUnderline: true,
                      ),
                      const SizedBox(height: 20),

                      //selection du statut
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statut',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('À faire'),
                                  selected: selectedStatus == 'todo',
                                  onSelected: (_) => setDialogState(() => selectedStatus = 'todo'),
                                  selectedColor: AppColors.ink,
                                  backgroundColor: AppColors.surface,
                                  labelStyle: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: selectedStatus == 'todo' ? FontWeight.w600 : FontWeight.w500,
                                    color: selectedStatus == 'todo' ? Colors.white : AppColors.textSecondary,
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: selectedStatus == 'todo' ? AppColors.ink : AppColors.borderStrong,
                                      width: 1.2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  showCheckmark: false,
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text('En cours'),
                                  selected: selectedStatus == 'in_progress',
                                  onSelected: (_) => setDialogState(() => selectedStatus = 'in_progress'),
                                  selectedColor: AppColors.ink,
                                  backgroundColor: AppColors.surface,
                                  labelStyle: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: selectedStatus == 'in_progress' ? FontWeight.w600 : FontWeight.w500,
                                    color: selectedStatus == 'in_progress' ? Colors.white : AppColors.textSecondary,
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: selectedStatus == 'in_progress' ? AppColors.ink : AppColors.borderStrong,
                                      width: 1.2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  showCheckmark: false,
                                ),
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: const Text('Terminée'),
                                  selected: selectedStatus == 'completed',
                                  onSelected: (_) => setDialogState(() => selectedStatus = 'completed'),
                                  selectedColor: AppColors.ink,
                                  backgroundColor: AppColors.surface,
                                  labelStyle: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: selectedStatus == 'completed' ? FontWeight.w600 : FontWeight.w500,
                                    color: selectedStatus == 'completed' ? Colors.white : AppColors.textSecondary,
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: selectedStatus == 'completed' ? AppColors.ink : AppColors.borderStrong,
                                      width: 1.2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  showCheckmark: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      //date d'echeance
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date limite',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setDialogState(() => selectedDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 8, top: 4),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.borderStrong, width: 1.4),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primarySoft,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month_rounded,
                                      size: 18,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      AppTextField(
                        label: 'Description',
                        controller: descController,
                        hintText: 'Précisions, contacts ou notes utiles…',
                        maxLines: 3,
                        isUnderline: true,
                      ),
                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text(
                              'Annuler',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.ink,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                            ),
                            onPressed: () async {
                              final title = titleController.text.trim();
                              if (title.isEmpty) return;

                              final success = await _controller.updateTaskDetails(
                                taskId: task.id!,
                                title: title,
                                description: descController.text.trim(),
                                dueDate: selectedDate,
                                status: selectedStatus,
                              );

                              if (success && mounted) {
                                Navigator.of(ctx).pop();
                              }
                            },
                            child: const Text('Enregistrer'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  //boite de dialogue de confirmation avant suppression
  void _confirmDeleteTask(TaskModel task) {
    if (task.id == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Supprimer la tâche ?',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Voulez-vous vraiment supprimer « ${task.title} » ? Cette action est irréversible.',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Annuler',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _controller.deleteTask(task.id!);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  //modal superpose centre avec box shadow pour afficher et modifier la tache
  void _showTaskDetailsModal(TaskModel task) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currentStatus = task.status;
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //entete avec titre et bouton fermer
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 19),
                          color: AppColors.textSecondary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Modifier la tâche',
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            _showEditTaskDialog(task);
                          },
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          color: AppColors.textTertiary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Fermer',
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    //description de la tache
                    if (task.description != null && task.description!.trim().isNotEmpty) ...[
                      Text(
                        task.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    //date d'echeance
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Échéance : ${_formatDueDate(task.dueDate)}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (task.isOverdue) ...[
                            const SizedBox(width: 8),
                            const Text(
                              '(En retard)',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    //selecteur interactif des trois statuts
                    const Text(
                      'Statut de la tâche',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildStatusOption(
                          label: 'À faire',
                          isSelected: currentStatus == 'todo',
                          activeColor: AppColors.textSecondary,
                          onTap: () async {
                            setModalState(() => task.status = 'todo');
                            await _controller.updateTaskStatus(task, 'todo');
                            setModalState(() {});
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildStatusOption(
                          label: 'En cours',
                          isSelected: currentStatus == 'in_progress',
                          activeColor: AppColors.info,
                          onTap: () async {
                            setModalState(() => task.status = 'in_progress');
                            await _controller.updateTaskStatus(task, 'in_progress');
                            setModalState(() {});
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildStatusOption(
                          label: 'Terminée',
                          isSelected: currentStatus == 'completed',
                          activeColor: AppColors.success,
                          onTap: () async {
                            setModalState(() => task.status = 'completed');
                            await _controller.updateTaskStatus(task, 'completed');
                            setModalState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    //action de suppression et fermeture
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          label: 'Supprimer définitivement cette tâche',
                          button: true,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            ),
                            icon: const Icon(Icons.delete_outline_rounded, size: 17),
                            label: const Text(
                              'Supprimer la tâche',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              _confirmDeleteTask(task);
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.ink,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Fermer', style: TextStyle(fontSize: 12.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //bouton d'option de statut dans le modal
  Widget _buildStatusOption({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.12) : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? activeColor : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  //carte pour chaque tache
  Widget _buildTaskCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => _showTaskDetailsModal(task),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //case a cocher pour basculer rapidement l'etat termine
              InkWell(
                onTap: () => _controller.toggleTaskCompletion(task),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2, right: 12),
                  decoration: BoxDecoration(
                    color: task.isCompleted ? AppColors.ink : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: task.isCompleted ? AppColors.ink : AppColors.borderStrong,
                      width: 1.5,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? AppColors.textTertiary : AppColors.textPrimary,
                      ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        AppTag(
                          _formatDueDate(task.dueDate),
                          dotColor: task.isOverdue
                              ? AppColors.error
                              : (task.isCompleted ? AppColors.success : AppColors.textTertiary),
                        ),
                        const SizedBox(width: 6),
                        AppTag(
                          task.displayStatus,
                          dotColor: task.isCompleted
                              ? AppColors.success
                              : (task.status == 'in_progress'
                                  ? AppColors.info
                                  : (task.isOverdue ? AppColors.error : AppColors.accent)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //bouton supprimer avec aria label et infobulle
              Semantics(
                label: 'Supprimer la tâche',
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  color: AppColors.textTertiary,
                  tooltip: 'Supprimer la tâche',
                  onPressed: () => _confirmDeleteTask(task),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //etat vide si aucune tache
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
                Icons.checklist_rounded,
                size: 24,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune tâche trouvée',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Organisez vos préparatifs en créant des tâches pour cet événement.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Créer une tâche',
              onPressed: _openCreateTask,
            ),
          ],
        ),
      ),
    );
  }
}
