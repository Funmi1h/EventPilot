import 'package:get/get.dart';
import 'package:eventpilot/data/models/expense_model.dart';
import 'package:eventpilot/data/services/expense_service.dart';
import 'package:eventpilot/data/services/event_service.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';

class ExpenseController extends GetxController {
  final ExpenseService _expenseService = ExpenseService();

  //l'identifiant de l'evenement courant et son budget
  var currentEventId = ''.obs;
  var initialBudget = 0.0.obs;

  //la liste observable des depenses
  var expenses = <ExpenseModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initExpenses();
  }

  //initialiser les depenses de l'evenement
  Future<void> initExpenses([String? eventId, double? budget]) async {
    if (eventId != null && eventId.isNotEmpty) {
      currentEventId.value = eventId;
      if (budget != null) initialBudget.value = budget;
    } else if (Get.arguments != null && Get.arguments is Map) {
      currentEventId.value = Get.arguments['eventId'] ?? '';
      initialBudget.value = (Get.arguments['budget'] as num?)?.toDouble() ?? 0.0;
    }

    if (currentEventId.value.isEmpty) {
      if (Get.isRegistered<EventController>() &&
          Get.find<EventController>().selectedEvent.value != null) {
        final ev = Get.find<EventController>().selectedEvent.value!;
        currentEventId.value = ev.id ?? '';
        initialBudget.value = ev.budget;
      } else {
        try {
          final events = await EventService().getEvents();
          if (events.isNotEmpty) {
            currentEventId.value = events.first.id ?? '';
            initialBudget.value = events.first.budget;
          }
        } catch (_) {}
      }
    }

    if (currentEventId.value.isNotEmpty) {
      await fetchExpenses(currentEventId.value);
    }
  }

  //lire les depenses depuis supabase
  Future<void> fetchExpenses(String eventId) async {
    currentEventId.value = eventId;
    try {
      isLoading.value = true;
      final fetched = await _expenseService.getExpensesByEvent(eventId);
      expenses.assignAll(fetched);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les dépenses : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //calcul du total des depenses
  double get totalExpenses {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  //calcul du budget restant
  double get remainingBudget {
    return initialBudget.value - totalExpenses;
  }

  //proportion du budget consomme
  double get usedRatio {
    if (initialBudget.value <= 0) return 0.0;
    return (totalExpenses / initialBudget.value).clamp(0.0, 1.0);
  }

  //alerte si budget depasse
  bool get isBudgetExceeded =>
      totalExpenses > initialBudget.value && initialBudget.value > 0;

  //alerte si budget faible
  bool get isBudgetLow {
    if (initialBudget.value <= 0) return false;
    return remainingBudget > 0 && (remainingBudget / initialBudget.value) <= 0.20;
  }

  //ajouter une nouvelle depense dans supabase
  Future<bool> addExpense({
    required String label,
    required double amount,
    required DateTime date,
  }) async {
    if (label.trim().isEmpty || amount <= 0) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un libellé et un montant valide.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    }

    try {
      isLoading.value = true;
      final newExpense = ExpenseModel(
        eventId: currentEventId.value,
        label: label.trim(),
        amount: amount,
        expenseDate: date,
      );

      final created = await _expenseService.createExpense(newExpense);
      expenses.insert(0, created); //on ajoute en haut de la liste

      return true;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de l\'ajout : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //mettre a jour une depense dans supabase
  Future<bool> updateExpenseDetails({
    required String expenseId,
    required String label,
    required double amount,
    required DateTime date,
  }) async {
    if (label.trim().isEmpty || amount <= 0) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un libellé et un montant valide.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    }

    try {
      isLoading.value = true;
      final updateData = {
        'label': label.trim(),
        'amount': amount,
        'expense_date': date.toIso8601String().split('T').first,
      };

      await _expenseService.updateExpense(expenseId, updateData);

      final index = expenses.indexWhere((e) => e.id == expenseId);
      if (index != -1) {
        expenses[index].label = label.trim();
        expenses[index].amount = amount;
        expenses[index].expenseDate = date;
        expenses.refresh();
      }

      Get.snackbar(
        'Succès',
        'Dépense modifiée avec succès.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de modifier la dépense : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //supprimer une depense dans supabase
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expenseService.deleteExpense(expenseId);
      expenses.removeWhere((e) => e.id == expenseId);
      Get.snackbar(
        'Succès',
        'Dépense supprimée.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }
}
