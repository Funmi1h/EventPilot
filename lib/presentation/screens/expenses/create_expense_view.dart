import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/screens/expenses/controller/expense_controller.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class CreateExpenseView extends StatefulWidget {
  final String? eventId;
  final Map<String, dynamic>? expenseToEdit;

  const CreateExpenseView({super.key, this.eventId, this.expenseToEdit});

  @override
  State<CreateExpenseView> createState() => _CreateExpenseViewState();
}

class _CreateExpenseViewState extends State<CreateExpenseView> {
  //recuperer ou instancier le controller des depenses
  final ExpenseController _controller = Get.isRegistered<ExpenseController>()
      ? Get.find<ExpenseController>()
      : Get.put(ExpenseController());

  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _labelController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  //choisir la date de la depense
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.ink,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  //formater la date pour l'affichage
  String get _formattedDate {
    return '${_selectedDate.day.toString().padLeft(2, '0')}/'
        '${_selectedDate.month.toString().padLeft(2, '0')}/'
        '${_selectedDate.year}';
  }

  //enregistrer la depense dans supabase
  void _saveExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final double amount = double.tryParse(
            _amountController.text.trim().replaceAll(' ', '').replaceAll(',', '.'),
          ) ??
          0.0;

      final success = await _controller.addExpense(
        label: _labelController.text.trim(),
        amount: amount,
        date: _selectedDate,
      );

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (success && mounted) {
        Navigator.of(context).pop(true);
        Get.snackbar(
          'Dépense enregistrée',
          'La dépense a été ajoutée avec succès.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    }
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
        title: const Text('Nouvelle dépense'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //en-tete avec titre et icone decorative
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ajouter une dépense',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.ink,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              //champ pour le libelle de la depense
              AppTextField(
                label: 'Libellé de la dépense',
                hintText: 'Ex. Acompte traiteur, Décoration florale',
                controller: _labelController,
                isUnderline: true,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Veuillez saisir un libellé';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              //champ pour le montant
              AppTextField(
                label: 'Montant (FCFA)',
                hintText: 'Ex. 150000',
                controller: _amountController,
                keyboardType: TextInputType.number,
                isUnderline: true,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Veuillez saisir un montant';
                  }
                  final parsed = double.tryParse(val.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Veuillez entrer un montant valide supérieur à 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              //selection de la date
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
                    onTap: _pickDate,
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
                            _formattedDate,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primarySoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              size: 20,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              //bouton pour enregistrer
              AppButton(
                label: 'Enregistrer la dépense',
                isLoading: _isLoading,
                onPressed: _saveExpense,
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Annuler',
                type: AppButtonType.text,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
