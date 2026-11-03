import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/data/models/expense_model.dart';

class ExpenseService {
  // creer une depense
  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    final response = await supabase
        .from('expenses')
        .insert(expense.toJson())
        .select()
        .single();

    return ExpenseModel.fromJson(response);
  }

  // récupérer toutes les dépenses d'un événement
  Future<List<ExpenseModel>> getExpensesByEvent(String eventId) async {
    final response = await supabase
        .from('expenses')
        .select()
        .eq('event_id', eventId)
        .order('expense_date', ascending: false);

    return (response as List)
        .map((json) => ExpenseModel.fromJson(json))
        .toList();
  }

  // modifier une dépense
  Future<void> updateExpense(String expenseId, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    await supabase.from('expenses').update(data).eq('id', expenseId);
  }

  // supprimer une dépense
  Future<void> deleteExpense(String expenseId) async {
    await supabase.from('expenses').delete().eq('id', expenseId);
  }
}