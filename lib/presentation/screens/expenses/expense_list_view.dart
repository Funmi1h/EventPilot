import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/screens/expenses/create_expense_view.dart';

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
      'icon': Icons.music_note_rounded,
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
      'icon': Icons.restaurant_rounded,
    },
    {
      'id': '4',
      'label': 'Réservation Salle Hôtel du Lac',
      'category': 'Lieu',
      'amount': 500000.0,
      'date': '15 oct. 2026',
      'icon': Icons.apartment_rounded,
    },
    {
      'id': '5',
      'label': 'Arche florale et centres de table',
      'category': 'Décoration',
      'amount': 200000.0,
      'date': '28 oct. 2026',
      'icon': Icons.local_florist_rounded,
    },
  ];

  double get _totalSpent =>
      _expenses.fold(0.0, (sum, item) => sum + (item['amount'] as double));

  double get _remainingBudget => _initialBudget - _totalSpent;

  double get _usedRatio =>
      _initialBudget > 0 ? (_totalSpent / _initialBudget).clamp(0.0, 1.0) : 0;

  bool get _isBudgetLow => _remainingBudget < (_initialBudget * 0.3) && _remainingBudget >= 0;
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
      middleText: 'Voulez-vous supprimer "${deleted['label']}" (${_formatAmount(deleted['amount'])} FCFA) ?',
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      buttonColor: AppColors.error,
      confirmTextColor: Colors.white,
      onConfirm: () {
        setState(() {
          _expenses.removeAt(index);
        });
        Get.back();
        Get.snackbar(
          'Dépense supprimée',
          'La dépense a été retirée du calcul du budget.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void _editExpense(int index) async {
    final result = await Get.to(() => CreateExpenseView(expenseToEdit: _expenses[index]));
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _expenses[index] = result;
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Budget & Dépenses',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary, size: 28),
            tooltip: 'Ajouter une dépense',
            onPressed: () async {
              final result = await Get.to(() => const CreateExpenseView());
              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  _expenses.insert(0, result);
                });
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── En-tête de synthèse budgétaire (3.4.5 & 3.4.6 & 3.4.7) ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Carte Synthèse jaune / dorée
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8B432), Color(0xFFC8921A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Budget restant',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${(_usedRatio * 100).round()} % consommé',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_formatAmount(_remainingBudget)} FCFA',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _usedRatio,
                            minHeight: 7,
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _isBudgetOver ? AppColors.error : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Budget initial', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                Text(
                                  '${_formatAmount(_initialBudget)} F',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Total dépensé', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                Text(
                                  '${_formatAmount(_totalSpent)} F',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Alerte budgétaire si budget faible (3.4.7) ──
                  if (_isBudgetLow || _isBudgetOver) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _isBudgetOver ? AppColors.errorSoft : AppColors.warningSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isBudgetOver ? AppColors.error.withValues(alpha: 0.3) : AppColors.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isBudgetOver ? Icons.error_outline : Icons.warning_amber_rounded,
                            color: _isBudgetOver ? AppColors.error : AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _isBudgetOver
                                  ? 'Dépassement de budget ! Le total dépensé dépasse le budget prévisionnel.'
                                  : 'Attention : le budget restant devient faible (${((1 - _usedRatio) * 100).round()}% restant).',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _isBudgetOver ? AppColors.error : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Filtre par catégorie ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: _categories.map((cat) {
                    final isSel = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        backgroundColor: const Color(0xFFF3F4F6),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          color: isSel ? Colors.white : AppColors.textSecondary,
                        ),
                        onSelected: (val) {
                          setState(() => _selectedCategory = cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Liste des dépenses enregistrées (3.4.2) ──
            Expanded(
              child: filteredExpenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 10),
                          const Text(
                            'Aucune dépense dans cette catégorie',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: filteredExpenses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.white),
                          ),
                          confirmDismiss: (dir) async {
                            _deleteExpense(realIndex);
                            return false;
                          },
                          child: InkWell(
                            onTap: () => _editExpense(realIndex),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      expense['icon'] as IconData? ?? Icons.payments_outlined,
                                      color: AppColors.accentPurple,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense['label'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF3F4F6),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                expense['category'],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              expense['date'],
                                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '- ${_formatAmount(expense['amount'])} F',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
                                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => const CreateExpenseView());
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _expenses.insert(0, result);
            });
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
