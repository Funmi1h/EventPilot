import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/data/models/expense_model.dart';
import 'package:eventpilot/presentation/screens/expenses/controller/expense_controller.dart';
import 'package:eventpilot/presentation/screens/expenses/create_expense_view.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  //recuperer ou instancier le controller des depenses
  final ExpenseController _controller = Get.put(ExpenseController());

  @override
  void initState() {
    super.initState();
    //initialiser les depenses avec les arguments passes
    _controller.initExpenses();
  }

  //ouvrir l'ecran d'ajout d'une depense
  void _openCreateExpense() {
    Get.to(
      () => const CreateExpenseView(),
      arguments: _controller.currentEventId.value,
    )?.then((_) {
      _controller.initExpenses();
    });
  }

  //formater les montants avec des espaces
  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  //formater la date en francais
  String _formatDate(DateTime date) {
    const months = [
      '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  //confirmer la suppression d'une depense
  void _confirmDeleteExpense(ExpenseModel expense) {
    if (expense.id == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Supprimer cette dépense ?',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Voulez-vous supprimer « ${expense.label} » (${_formatAmount(expense.amount)} FCFA) ? Cette action est irréversible.',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Annuler',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _controller.deleteExpense(expense.id!);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  //boite de dialogue pour modifier une depense
  void _showEditExpenseDialog(ExpenseModel expense) {
    final labelController = TextEditingController(text: expense.label);
    final amountController = TextEditingController(
      text: expense.amount.toStringAsFixed(0),
    );
    DateTime selectedDate = expense.expenseDate;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.ink,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Modifier la dépense',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          color: AppColors.textTertiary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Libellé de la dépense',
                      controller: labelController,
                      hintText: 'Ex. Location sonorisation',
                      isUnderline: true,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Montant (FCFA)',
                      controller: amountController,
                      hintText: 'Ex. 150000',
                      keyboardType: TextInputType.number,
                      isUnderline: true,
                    ),
                    const SizedBox(height: 20),

                    //date de la depense
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date de la dépense',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setDialogState(() => selectedDate = picked);
                            }
                          },
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
                                  _formatDate(selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primarySoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 18,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text(
                            'Annuler',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.ink,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                          ),
                          onPressed: () async {
                            final label = labelController.text.trim();
                            final amount = double.tryParse(
                                  amountController.text
                                      .trim()
                                      .replaceAll(' ', '')
                                      .replaceAll(',', '.'),
                                ) ??
                                0.0;
                            if (label.isEmpty || amount <= 0) return;

                            final success = await _controller.updateExpenseDetails(
                              expenseId: expense.id!,
                              label: label,
                              amount: amount,
                              date: selectedDate,
                            );

                            if (success && mounted) {
                              Navigator.of(ctx).pop();
                            }
                          },
                          child: const Text('Enregistrer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //modal pour afficher les details d'une depense
  void _showExpenseDetailsModal(ExpenseModel expense) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppIconBox(icon: Icons.payments_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.label,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatDate(expense.expenseDate),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 19),
                      color: AppColors.textSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Modifier la dépense',
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _showEditExpenseDialog(expense);
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: AppColors.textTertiary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Fermer',
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Montant décaissé',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatAmount(expense.amount)} FCFA',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      label: 'Supprimer définitivement la dépense',
                      button: true,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        ),
                        icon: const Icon(Icons.delete_outline_rounded, size: 17),
                        label: const Text(
                          'Supprimer',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _confirmDeleteExpense(expense);
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Fermer', style: TextStyle(fontSize: 12.5)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
        title: const Text('Dépenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            tooltip: 'Nouvelle dépense',
            onPressed: _openCreateExpense,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            //carte du budget
            _buildBudgetCard(),

            //liste reactive des depenses
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.ink),
                  );
                }

                final expenses = _controller.expenses;

                if (expenses.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  color: AppColors.ink,
                  onRefresh: () => _controller.fetchExpenses(_controller.currentEventId.value),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final item = expenses[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: InkWell(
                          onTap: () => _showExpenseDetailsModal(item),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const AppIconBox(icon: Icons.payments_outlined),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.label,
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatDate(item.expenseDate),
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${_formatAmount(item.amount)} F',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Semantics(
                                  label: 'Supprimer la dépense',
                                  button: true,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                    color: AppColors.textTertiary,
                                    tooltip: 'Supprimer la dépense',
                                    onPressed: () => _confirmDeleteExpense(item),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //carte recapitulative du budget
  Widget _buildBudgetCard() {
    return Obx(() {
      final initial = _controller.initialBudget.value;
      final spent = _controller.totalExpenses;
      final remaining = _controller.remainingBudget;
      final ratio = _controller.usedRatio;

      return Container(
        margin: const EdgeInsets.fromLTRB(22, 8, 22, 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                AppTag(
                  _controller.isBudgetExceeded
                      ? 'Dépassé'
                      : (_controller.isBudgetLow ? 'Faible' : 'Sain'),
                  dotColor: _controller.isBudgetExceeded
                      ? AppColors.error
                      : (_controller.isBudgetLow ? AppColors.warning : AppColors.success),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatAmount(remaining)} FCFA',
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
                value: ratio,
                minHeight: 5,
                backgroundColor: Colors.white.withOpacity(0.18),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _controller.isBudgetExceeded
                      ? AppColors.error
                      : (_controller.isBudgetLow ? AppColors.warning : AppColors.accent),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total : ${_formatAmount(initial)} FCFA',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Text(
                  'Dépensé : ${_formatAmount(spent)} FCFA',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  //vue si aucune depense
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 24,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune dépense enregistrée',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Suivez les coûts de votre événement en ajoutant vos premières dépenses.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Ajouter une dépense',
              onPressed: _openCreateExpense,
            ),
          ],
        ),
      ),
    );
  }
}
