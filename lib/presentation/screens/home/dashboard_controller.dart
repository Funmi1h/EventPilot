import 'package:get/get.dart';
import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/event_model.dart';
import 'package:eventpilot/data/models/task_model.dart';
import 'package:eventpilot/data/models/expense_model.dart';
import 'package:eventpilot/data/services/event_service.dart';
import 'package:eventpilot/data/services/task_service.dart';
import 'package:eventpilot/data/services/expense_service.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';

class DashboardController extends GetxController {
  final EventService _eventService = EventService();
  final TaskService _taskService = TaskService();
  final ExpenseService _expenseService = ExpenseService();

  var isLoading = false.obs;
  var currentEvent = Rxn<EventModel>();
  var tasks = <TaskModel>[].obs;
  var expenses = <ExpenseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initDashboard();
  }

  Future<void> initDashboard([EventModel? event]) async {
    isLoading.value = true;
    try {
      if (event != null) {
        currentEvent.value = event;
      } else if (Get.arguments != null && Get.arguments is EventModel) {
        currentEvent.value = Get.arguments as EventModel;
      } else if (Get.isRegistered<EventController>() &&
          Get.find<EventController>().selectedEvent.value != null) {
        currentEvent.value = Get.find<EventController>().selectedEvent.value;
      } else {
        final events = await _eventService.getEvents();
        if (events.isNotEmpty) {
          currentEvent.value = events.first;
        } else {
          currentEvent.value = null;
        }
      }

      if (currentEvent.value?.id != null) {
        await loadEventData(currentEvent.value!.id!);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger le tableau de bord : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEventData(String eventId) async {
    try {
      final fetchedTasks = await _taskService.getTasksByEvent(eventId);
      tasks.assignAll(fetchedTasks);

      final fetchedExpenses = await _expenseService.getExpensesByEvent(eventId);
      expenses.assignAll(fetchedExpenses);
    } catch (_) {
      // Les données partielles peuvent être ignorées sans planter l'UI
    }
  }

  // --- Propriétés utilisateur ---
  String get userName {
    final user = supabase.auth.currentUser;
    if (user == null) return 'Organisateur';
    final metadataName = user.userMetadata?['full_name'];
    if (metadataName != null && metadataName.toString().trim().isNotEmpty) {
      return metadataName.toString().trim();
    }
    if (user.email != null && user.email!.contains('@')) {
      return user.email!.split('@').first;
    }
    return 'Organisateur';
  }

  String get userInitials {
    final parts = userName.trim().split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'EP';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // --- Calculs Budget ---
  double get totalExpenses =>
      expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get initialBudget => currentEvent.value?.budget ?? 0.0;

  double get remainingBudget => initialBudget - totalExpenses;

  double get budgetUsedRatio {
    if (initialBudget <= 0) return 0.0;
    return (totalExpenses / initialBudget).clamp(0.0, 1.0);
  }

  bool get isBudgetLow {
    if (initialBudget <= 0) return false;
    return remainingBudget > 0 && (remainingBudget / initialBudget) <= 0.20;
  }

  bool get isBudgetExceeded =>
      initialBudget > 0 && totalExpenses > initialBudget;

  // --- Calculs Tâches ---
  int get completedTasksCount => tasks.where((t) => t.isCompleted).length;
  int get overdueTasksCount => tasks.where((t) => t.isOverdue).length;
  int get remainingTasksCount => tasks.where((t) => !t.isCompleted).length;

  double get taskProgressRatio {
    if (tasks.isEmpty) return 0.0;
    return (completedTasksCount / tasks.length).clamp(0.0, 1.0);
  }

  // --- Compte à rebours J-X ---
  String get countdownText {
    final event = currentEvent.value;
    if (event == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(event.date.year, event.date.month, event.date.day);
    final diff = eventDay.difference(today).inDays;

    if (diff > 0) return 'J-$diff';
    if (diff == 0) return 'Aujourd\'hui';
    return 'Terminé';
  }
}
