import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/screens/expenses/create_expense_view.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  final double _initialBudget = 2500000;
  String _selectedCategory = 'Toutes';

  final List<String> _categories = [
    'Toutes',
    'Animation',
    'Impression',
    'Traiteur',
    'Décoration',
    'Lieu',
    'Logistique',
  ];

  final List<Map<String, dynamic>> _expenses = [
    {
      'id': '1',
      'label': 'Sonorisation DJ Max',
      'category': 'Animation',
      'amount': 150000.0,
      'date': '21 oct. 2026',
      'icon': Icons.music_note_outlined,
    },
    {
      'id': '2',
      'label': 'Faire-part imprimés (150 ex)',
      'category': 'Impression',
      'amount': 100000.0,
      'date': '22 oct. 2026',
      'icon': Icons.description_outlined,
    },
    {
      'id': '3',
      'label': 'Acompte traiteur Saveurs du Bénin',
      'category': 'Traiteur',
      'amount': 850000.0,
      'date': '24 oct. 2026',
      'icon': Icons.restaurant_outlined,
    },
    {
      'id': '4',
      'label': 'Réservation Salle Hôtel du Lac',
      'category': 'Lieu',
      'amount': 500000.0,
      'date': '15 oct. 2026',
      'icon': Icons.apartment_outlined,
    },
    {
      'id': '5',
      'label': 'Arche florale et centres de table',
      'category': 'Décoration',
      'amount': 200000.0,
      'date': '28 oct. 2026',
      'icon': Icons.local_florist_outlined,
    },
  ];

  double get _totalSpent =>
      _expenses.fold(0.0, (sum, item) => sum + (item['amount'] as double));

  double get _remainingBudget => _initialBudget - _totalSpent;

  double get _usedRatio =>
      _initialBudget > 0 ? (_totalSpent / _initialBudget).clamp(0.0, 1.0) : 0;

  bool get _isBudgetLow =>
      _remainingBudget < (_initialBudget * 0.3) && _remainingBudget >= 0;
  bool get _isBudgetOver => _remainingBudget < 0;

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  void _deleteExpense(int index) {
    final deleted = _expenses[index];
    Get.defaultDialog(
      title: 'Supprimer cette dépense ?',
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      middleText:
          '« ${deleted['label']} » (${_formatAmount(deleted['amount'])} FCFA) sera retirée du calcul.',
      middleTextStyle: const TextStyle(
        fontSize: 13,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      buttonColor: AppColors.ink,
      confirmTextColor: Colors.white,
      cancelTextColor: AppColors.textSecondary,
      onConfirm: () {
        setState(() {
          _expenses.removeAt(index);
        });
        Get.back();
        Get.snackbar('Dépense supprimée', 'Le budget a été recalculé.');
      },
    );
  }

  void _editExpense(int index) async {
    final result =
        await Get.to(() => CreateExpenseView(expenseToEdit: _expenses[index]));
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _expenses[index] = result;
      });
    }
  }

  Future<void> _addExpense() async {
    final result = await Get.to(() => const CreateExpenseView());
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _expenses.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _selectedCategory == 'Toutes'
        ? _expenses
        : _expenses.where((e) => e['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.back(),
        ),
        title: const Text('Budget & dépenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            tooltip: 'Ajouter une dépense',
            onPressed: _addExpense,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 6, 22, 16),
              child: _buildBudgetCard(),
            ),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
                child: Row(
                  children: _categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: AppFilterChip(
                        label: cat,
                        selected: _selectedCategory == cat,
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: filteredExpenses.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(22, 2, 22, 28),
                      itemCount: filteredExpenses.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 9),
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        final realIndex = _expenses.indexOf(expense);

                        return Dismissible(
                          key: Key(expense['id'] ?? index.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                          ),
                          confirmDismiss: (dir) async {
                            _deleteExpense(realIndex);
                            return false;
                          },
                          child: InkWell(
                            onTap: () => _editExpense(realIndex),
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  AppIconBox(
                                    icon: expense['icon'] as IconData? ??
                                        Icons.payments_outlined,
                                    size: 40,
                                    iconSize: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense['label'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.35,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${expense['category']} · ${expense['date']}',
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            color: AppColors.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '− ${_formatAmount(expense['amount'])} F',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget restant',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatAmount(_remainingBudget)} FCFA',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.8,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: _usedRatio,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Initial',
                    style: TextStyle(fontSize: 10.5, color: Colors.white54),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_formatAmount(_initialBudget)} F',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Dépensé',
                    style: TextStyle(fontSize: 10.5, color: Colors.white54),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_formatAmount(_totalSpent)} F · ${(_usedRatio * 100).round()} %',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_isBudgetLow || _isBudgetOver) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isBudgetOver
                          ? 'Le total dépensé dépasse le budget prévisionnel.'
                          : 'Le budget restant devient faible (${((1 - _usedRatio) * 100).round()} % restant).',
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.45,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 21,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Aucune dépense',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cette catégorie est encore vide.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
