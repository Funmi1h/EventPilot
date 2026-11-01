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
    if (widget.expenseToEdit != null && widget.expenseToEdit!['category'] != null) {
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
              primary: AppColors.primary,
              onPrimary: Colors.white,
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
        return Icons.music_note_rounded;
      case 'Impression':
        return Icons.description_outlined;
      case 'Traiteur':
        return Icons.restaurant_rounded;
      case 'Lieu':
        return Icons.apartment_rounded;
      case 'Décoration':
        return Icons.local_florist_rounded;
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

      final double amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

      final expenseData = {
        'id': widget.expenseToEdit?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
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
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successSoft,
        colorText: AppColors.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _isEditing ? 'Modifier la dépense' : 'Nouvelle dépense',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Libellé ──
              AppTextField(
                label: 'Libellé de la dépense',
                hintText: 'Ex: Acompte traiteur, DJ, Location chaises...',
                controller: _labelController,
                prefixIcon: Icons.receipt_long_outlined,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez saisir un libellé' : null,
              ),

              const SizedBox(height: 20),

              // ── Montant ──
              AppTextField(
                label: 'Montant (FCFA)',
                hintText: 'Ex: 150000',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.payments_outlined,
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

              const SizedBox(height: 20),

              // ── Catégorie ──
              const Text(
                'Catégorie',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
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
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Date de la dépense ──
              const Text(
                'Date de la dépense',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Bouton Enregistrer ──
              AppButton(
                label: _isEditing ? 'Mettre à jour la dépense' : 'Enregistrer la dépense',
                isLoading: _isLoading,
                icon: Icons.check_circle_outline,
                onPressed: _saveExpense,
              ),

              const SizedBox(height: 12),

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
