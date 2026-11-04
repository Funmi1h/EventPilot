import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/data/models/task_model.dart';
import 'package:eventpilot/data/services/task_service.dart';
import 'package:eventpilot/presentation/screens/tasks/controller/task_controller.dart';

class CreateTaskController extends GetxController {
  final TaskService _taskService = TaskService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var selectedDueDate = DateTime.now().add(const Duration(days: 7)).obs;
  var selectedDisplayStatus = 'À faire'.obs;
  final List<String> displayStatuses = const ['À faire', 'En cours', 'Terminée'];

  var enableReminder = true.obs;
  var isLoading = false.obs;

  late String eventId;

  @override
  void onInit() {
    super.onInit();
    eventId = Get.arguments is String ? (Get.arguments as String) : '';
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      selectedDueDate.value = picked;
    }
  }

  String get formattedDueDate {
    final date = selectedDueDate.value;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _mapDisplayToDatabaseStatus(String display) {
    switch (display) {
      case 'Terminée':
        return 'completed';
      case 'En cours':
        return 'in_progress';
      case 'À faire':
      default:
        return 'todo';
    }
  }

  void changeStatus(String displayStatus) {
    selectedDisplayStatus.value = displayStatus;
  }

  void toggleReminder(bool value) {
    enableReminder.value = value;
  }

  Future<void> saveTask() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'Champ requis',
        'Veuillez renseigner le titre de la tâche.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (eventId.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Aucun événement relié à cette tâche.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    try {
      isLoading.value = true;

      final newTask = TaskModel(
        eventId: eventId,
        title: title,
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        dueDate: selectedDueDate.value,
        status: _mapDisplayToDatabaseStatus(selectedDisplayStatus.value),
        enableReminder: enableReminder.value,
      );

      final created = await _taskService.createTask(newTask);

      if (Get.isRegistered<TaskListController>()) {
        Get.find<TaskListController>().tasks.add(created);
      }

      Get.back();
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
      isLoading.value = false;
    }
  }

  void cancel() => Get.back();
}
