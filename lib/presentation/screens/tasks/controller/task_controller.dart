import 'package:get/get.dart';
import 'package:eventpilot/data/models/task_model.dart';
import 'package:eventpilot/data/services/task_service.dart';
import 'package:eventpilot/data/services/event_service.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';

class TaskListController extends GetxController {
  final TaskService _taskService = TaskService();

  var currentEventId = ''.obs;
  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;

  var selectedFilter = 'Toutes'.obs;
  final List<String> filters = const [
    'Toutes',
    'À faire',
    'En cours',
    'En retard',
    'Terminées',
  ];

  @override
  void onInit() {
    super.onInit();
    initTasks();
  }

  Future<void> initTasks([String? eventId]) async {
    if (eventId != null && eventId.isNotEmpty) {
      currentEventId.value = eventId;
      await fetchTasks(eventId);
      return;
    }

    if (Get.arguments != null &&
        Get.arguments is String &&
        (Get.arguments as String).isNotEmpty) {
      currentEventId.value = Get.arguments as String;
      await fetchTasks(currentEventId.value);
    } else if (Get.isRegistered<EventController>() &&
        Get.find<EventController>().selectedEvent.value?.id != null) {
      currentEventId.value =
          Get.find<EventController>().selectedEvent.value!.id!;
      await fetchTasks(currentEventId.value);
    } else {
      try {
        final events = await EventService().getEvents();
        if (events.isNotEmpty && events.first.id != null) {
          currentEventId.value = events.first.id!;
          await fetchTasks(currentEventId.value);
        }
      } catch (_) {}
    }
  }

  Future<void> fetchTasks(String eventId) async {
    currentEventId.value = eventId;
    try {
      isLoading.value = true;
      final fetched = await _taskService.getTasksByEvent(eventId);
      tasks.assignAll(fetched);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les tâches : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<TaskModel> get filteredTasks {
    switch (selectedFilter.value) {
      case 'À faire':
        return tasks.where((t) => t.status == 'todo' && !t.isOverdue).toList();
      case 'En cours':
        return tasks.where((t) => t.status == 'in_progress').toList();
      case 'En retard':
        return tasks.where((t) => t.isOverdue).toList();
      case 'Terminées':
        return tasks.where((t) => t.isCompleted).toList();
      default:
        return tasks;
    }
  }

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get overdueCount => tasks.where((t) => t.isOverdue).length;
  int get remainingCount => tasks.where((t) => !t.isCompleted).length;

  double get progressRatio =>
      tasks.isEmpty ? 0.0 : (completedCount / tasks.length);

  int get progressPercentage => (progressRatio * 100).round();

  //basculer rapidement l'etat termine
  Future<void> toggleTaskCompletion(TaskModel task) async {
    if (task.id == null) return;
    final newStatus = task.isCompleted ? 'todo' : 'completed';

    try {
      await _taskService.updateTask(task.id!, {'status': newStatus});
      task.status = newStatus;
      tasks.refresh();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de modifier le statut : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }

  //modifier le statut vers a faire, en cours ou terminee
  Future<void> updateTaskStatus(TaskModel task, String newStatus) async {
    if (task.id == null) return;
    try {
      await _taskService.updateTask(task.id!, {'status': newStatus});
      task.status = newStatus;
      tasks.refresh();
      Get.snackbar(
        'Statut mis à jour',
        'La tâche est passée à : ${task.displayStatus}',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de modifier le statut : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }

  //modifier les informations completes de la tache
  Future<bool> updateTaskDetails({
    required String taskId,
    required String title,
    String? description,
    required DateTime dueDate,
    required String status,
  }) async {
    if (title.trim().isEmpty) {
      Get.snackbar(
        'Champ requis',
        'Le titre de la tâche ne peut pas être vide.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    }

    try {
      final updateData = {
        'title': title.trim(),
        'description': description?.trim().isNotEmpty == true ? description!.trim() : null,
        'due_date': dueDate.toIso8601String(),
        'status': status,
      };

      await _taskService.updateTask(taskId, updateData);

      final index = tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        tasks[index].title = title.trim();
        tasks[index].description = description?.trim().isNotEmpty == true ? description!.trim() : null;
        tasks[index].dueDate = dueDate;
        tasks[index].status = status;
        tasks.refresh();
      }

      Get.snackbar(
        'Succès',
        'Tâche modifiée avec succès.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de modifier la tâche : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    }
  }

  //supprimer une tache apres confirmation
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      tasks.removeWhere((t) => t.id == taskId);
      Get.snackbar(
        'Succès',
        'Tâche supprimée avec succès.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer la tâche : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }
}
