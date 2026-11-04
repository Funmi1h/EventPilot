import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/data/models/task_model.dart';
import 'package:eventpilot/data/services/task_service.dart';
import 'package:eventpilot/presentation/screens/tasks/controller/task_controller.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class CreateTaskView extends StatefulWidget {
  final String? eventId;

  const CreateTaskView({super.key, this.eventId});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final TaskService _taskService = TaskService();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  String _status = 'todo';
  bool _isLoading = false;
  String _targetEventId = '';

  final List<Map<String, String>> _statusOptions = [
    {'label': 'À faire', 'value': 'todo'},
    {'label': 'En cours', 'value': 'in_progress'},
    {'label': 'Terminée', 'value': 'completed'},
  ];

  @override
  void initState() {
    super.initState();
    //on recupere l'id de l'evenement
    if (widget.eventId != null && widget.eventId!.isNotEmpty) {
      _targetEventId = widget.eventId!;
    } else if (Get.arguments is String && (Get.arguments as String).isNotEmpty) {
      _targetEventId = Get.arguments as String;
    } else if (Get.isRegistered<TaskListController>()) {
      _targetEventId = Get.find<TaskListController>().currentEventId.value;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //choisir la date limite
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.ink,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  //formater la date pour l'affichage
  String get _formattedDate {
    return '${_deadline.day.toString().padLeft(2, '0')}/'
        '${_deadline.month.toString().padLeft(2, '0')}/'
        '${_deadline.year}';
  }

  //enregistrer la tache dans supabase
  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'Champ requis',
        'Veuillez saisir le titre de la tâche.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (_targetEventId.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Aucun événement associé à cette tâche.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      final newTask = TaskModel(
        eventId: _targetEventId,
        title: title,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        dueDate: _deadline,
        status: _status,
      );

      final created = await _taskService.createTask(newTask);

      //ajouter directement dans le controller si present
      if (Get.isRegistered<TaskListController>()) {
        Get.find<TaskListController>().tasks.add(created);
      }

      Navigator.of(context).pop();
      Get.snackbar(
        'Succès',
        'Tâche créée avec succès !',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de créer la tâche : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        title: const Text('Nouvelle tâche'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //en-tete avec titre et icone decorative
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Créer une tâche',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: AppColors.ink,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            //champ pour le nom de la tache
            AppTextField(
              label: 'Nom de la tâche',
              hintText: 'Ex. Confirmer le traiteur',
              controller: _titleController,
              isUnderline: true,
            ),
            const SizedBox(height: 24),

            //selection du statut sous forme de pilules
            const Text(
              'Statut initial',
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
                children: _statusOptions.map((opt) {
                  final isSelected = _status == opt['value'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(opt['label']!),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _status = opt['value']!),
                      selectedColor: AppColors.ink,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? AppColors.ink : AppColors.borderStrong,
                          width: 1.2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            //selection de la date limite
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
                  onTap: _pickDate,
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
                          _formattedDate,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primarySoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            size: 20,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            //description detaillee de la tache
            AppTextField(
              label: 'Description',
              hintText: 'Détails, contacts ou notes utiles…',
              controller: _descriptionController,
              maxLines: 3,
              isUnderline: true,
            ),
            const SizedBox(height: 36),

            //bouton pour enregistrer la tache
            AppButton(
              label: 'Créer la tâche',
              isLoading: _isLoading,
              onPressed: _saveTask,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Annuler',
              type: AppButtonType.text,
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
