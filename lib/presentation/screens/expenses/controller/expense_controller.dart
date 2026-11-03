import 'package:get/get.dart';
import 'package:eventpilot/data/models/expense_model.dart';
import 'package:eventpilot/data/services/expense_service.dart';

class ExpenseController extends GetxController {
  final ExpenseService _expenseService = ExpenseService();

  var currentEventId = ''.obs;
  //le budget prévisionnel
  var initialBudget = 0.0.obs; 

  var expenses = <ExpenseModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      currentEventId.value = Get.arguments['eventId'] ?? '';
      initialBudget.value = (Get.arguments['budget'] as num?)?.toDouble() ?? 0.0;
      if (currentEventId.value.isNotEmpty) {
        fetchExpenses(currentEventId.value);
      }
    }
  }

  // 1. LIRE les dépenses
  Future<void> fetchExpenses(String eventId) async {
    currentEventId.value = eventId;
    try {
      isLoading.value = true;
      final fetched = await _expenseService.getExpensesByEvent(eventId);
      expenses.assignAll(fetched);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les dépenses : $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- RÈGLES MÉTIERS CALCULS DU BUDGET ---

  // 3.4.5 : Total des dépenses cumulées
  double get totalExpenses {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  // 3.4.6 : Budget restant = Budget initial - Total dépenses
  double get remainingBudget {
    return initialBudget.value - totalExpenses;
  }

  // 3.4.7 : Alertes budgétaires
  // Dépassement de budget (dépenses > budget initial)
  bool get isBudgetExceeded => totalExpenses > initialBudget.value && initialBudget.value > 0;

  // Budget faible (moins de 15% restant)
  bool get isBudgetLow {
    if (initialBudget.value <= 0) return false;
    return remainingBudget > 0 && (remainingBudget / initialBudget.value) <= 0.15;
  }

  // 2. AJOUTER une dépense
  Future<bool> addExpense({
    required String label,
    required double amount,
    required DateTime date,
  }) async {
    if (label.trim().isEmpty || amount <= 0) {
      Get.snackbar('Erreur', 'Veuillez saisir un libellé et un montant valide.');
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
      expenses.insert(0, created); // Ajoute en haut de liste

      Get.snackbar('Succès', 'Dépense enregistrée.');
      return true;
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de l\'ajout : $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 3. MODIFIER une dépense
  Future<void> updateExpense(ExpenseModel expense, String newLabel, double newAmount) async {
    if (expense.id == null) return;

    try {
      await _expenseService.updateExpense(expense.id!, {
        'label': newLabel,
        'amount': newAmount,
      });

      // Modification directe en mémoire
      expense.label = newLabel;
      expense.amount = newAmount;
      expenses.refresh();

      Get.snackbar('Succès', 'Dépense mise à jour.');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier la dépense : $e');
    }
  }

  // 4. SUPPRIMER une dépense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expenseService.deleteExpense(expenseId);
      expenses.removeWhere((item) => item.id == expenseId);
      Get.snackbar('Succès', 'Dépense supprimée.');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer la dépense : $e');
    }
  }
}