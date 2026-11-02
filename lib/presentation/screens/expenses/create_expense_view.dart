import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class CreateExpenseView extends StatefulWidget {
  final Map<String, dynamic>? expenseToEdit;

  const CreateExpenseView({super.key, this.expenseToEdit});

  @override
  State<CreateExpenseView> createState() => _CreateExpenseViewState();
}

class _CreateExpenseViewState extends State<CreateExpenseView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _amountController;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Traiteur';
  bool _isLoading = false;

  final List<String> _categories = [
    'Traiteur',
    'Décoration',
    'Lieu',
    'Animation',
    'Impression',
    'Logistique',
    'Tenue',
    'Autre',
  ];

  bool get _isEditing => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.expenseToEdit?['label'] ?? '',
    );
    _amountController = TextEditingController(
      text: widget.expenseToEdit != null
          ? (widget.expenseToEdit!['amount'] as double).toInt().toString()
          : '',
    );
    if (widget.expenseToEdit != null &&
        widget.expenseToEdit!['category'] != null) {
      _selectedCategory = widget.expenseToEdit!['category'];
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

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

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Animation':
        return Icons.music_note_outlined;
      case 'Impression':
        return Icons.description_outlined;
      case 'Traiteur':
        return Icons.restaurant_outlined;
      case 'Lieu':
        return Icons.apartment_outlined;
      case 'Décoration':
        return Icons.local_florist_outlined;
      case 'Logistique':
        return Icons.local_shipping_outlined;
      case 'Tenue':
        return Icons.checkroom_outlined;
      default:
        return Icons.payments_outlined;
    }
  }

  void _saveExpense() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _isLoading = false);

      final double amount =
          double.tryParse(_amountController.text.trim()) ?? 0.0;

      final expenseData = {
        'id': widget.expenseToEdit?['id'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        'label': _labelController.text.trim(),
        'category': _selectedCategory,
        'amount': amount,
        'date': _formatDate(_selectedDate),
        'icon': _iconForCategory(_selectedCategory),
      };

      Get.back(result: expenseData);
      Get.snackbar(
        _isEditing ? 'Dépense modifiée' : 'Dépense enregistrée',
        'Le budget restant a été mis à jour.',
      );
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
        title: Text(_isEditing ? 'Modifier la dépense' : 'Nouvelle dépense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Libellé de la dépense',
                hintText: 'Ex. Acompte traiteur, DJ, location…',
                controller: _labelController,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Veuillez saisir un libellé'
                    : null,
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'Montant (FCFA)',
                hintText: 'Ex. 150 000',
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Veuillez renseigner le montant';
                  }
                  if (double.tryParse(v.trim()) == null) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              const Text(
                'Catégorie',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
                style: const TextStyle(
                  fontSize: 14.5,
                  color: AppColors.textPrimary,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'Date de la dépense',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              AppButton(
                label: _isEditing
                    ? 'Mettre à jour la dépense'
                    : 'Enregistrer la dépense',
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
