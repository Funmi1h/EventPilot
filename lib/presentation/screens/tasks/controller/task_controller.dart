import 'package:get/get.dart';
import 'package:eventpilot/data/models/task_model.dart';
import 'package:eventpilot/data/services/task_service.dart';
import 'package:eventpilot/presentation/screens/tasks/create_task_view.dart';

class TaskListController extends GetxController {
  final TaskService _taskService = TaskService();

  // id de l'événement dont on affiche les tâches
  var currentEventId = ''.obs;

  // liste réactive des tâches et indicateur de chargement
  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;

  // Filtre sélectionné par l'utilisateur
  var selectedFilter = 'Toutes'.obs;
  final List<String> filters = const [
    'Toutes',
    'À faire',
    'En cours',
    'En retard',
  ];

  @override
  void onInit() {
    super.onInit();
    // Récupère l'ID de l'événement s'il a été transmis par la page précédente
    if (Get.arguments != null && Get.arguments is String) {
      currentEventId.value = Get.arguments as String;
      fetchTasks(currentEventId.value);
    }
  }

  //lire les tâches depuis Supabase
  Future<void> fetchTasks(String eventId) async {
    currentEventId.value = eventId;
    try {
      isLoading.value = true;
      final fetched = await _taskService.getTasksByEvent(eventId);
      tasks.assignAll(fetched);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les tâches : $e');
    } finally {
      isLoading.value = false;
    }
  }

  // filtrer les taches selon les bouttons selectionnés 
  void changeFilter(String filter) {
    selectedFilter.value = filter; //ca permet de changer la valeur du filtre selectionné
  }

  List<TaskModel> get filteredTasks {
    if (selectedFilter.value == 'À faire') {
      return tasks.where((t) => t.status == 'todo').toList();
    }
    if (selectedFilter.value == 'En cours') {
      return tasks.where((t) => t.status == 'in_progress').toList();
    }
    if (selectedFilter.value == 'En retard') {
      return tasks.where((t) => t.isOverdue).toList();
    }
    return tasks; // 'Toutes'
  }

  // Indicateurs pour l'en-tête (57 %, 8/14 tâches faites, etc.)
  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get overdueCount => tasks.where((t) => t.isOverdue).length;

  double get progressRatio =>
      tasks.isEmpty ? 0.0 : (completedCount / tasks.length);

  int get progressPercentage => (progressRatio * 100).round();

  // modifier le statut d'une tache en mode coché décoché la case
  Future<void> toggleTaskCompletion(TaskModel task) async {
    if (task.id == null) return;

    final newStatus = task.isCompleted ? 'todo' : 'completed';

    try {
      // on met a jour le statut de la tache  dans Supabase
      //le  c'est pour dire que la variable ne sera jamais nulle
      await _taskService.updateTask(task.id!, {'status': newStatus});

      //on modifie directement l'objet en mémoire 
      task.status = newStatus;

      //on rafraichit en quelque sorte la liste des taches sur l'ecran
      tasks.refresh();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le statut : $e');
    }
  }

  // supprimer une tache
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      tasks.removeWhere((t) => t.id == taskId);
      Get.snackbar('Succès', 'Tâche supprimée avec succès.');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer la tâche : $e');
    }
  }

  // 5. NAVIGATION
  void goToCreateTask() {
    Get.to(() => const CreateTaskView(), arguments: currentEventId.value);
  }

  void goBack() => Get.back();
}