import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class EditEventView extends StatefulWidget {
  final Map<String, dynamic>? eventData;

  const EditEventView({super.key, this.eventData});

  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _budgetController;
  late TextEditingController _feeController;
  late TextEditingController _descriptionController;
  late String _eventType;
  late bool _isPaid;
  bool _isLoading = false;

  final List<String> _types = [
    'Mariage',
    'Baptême',
    'Anniversaire',
    'Conférence',
    'Soirée',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    // Utilise les arguments GetX si disponibles, sinon données mockées
    final args = Get.arguments as Map<String, dynamic>?;
    final data = widget.eventData ?? args ?? {};
    _titleController = TextEditingController(text: data['title'] ?? 'Mariage Rita & Marc');
    _locationController = TextEditingController(text: data['location'] ?? 'Hôtel du Lac, Cotonou');
    _budgetController = TextEditingController(
      text: (data['budgetInitial'] ?? '2500000').toString().replaceAll(' FCFA', '').replaceAll(' ', ''),
    );
    _feeController = TextEditingController(
      text: (data['fee'] ?? '15000').toString().replaceAll(' FCFA', '').replaceAll(' ', ''),
    );
    _descriptionController = TextEditingController(
      text: data['description'] ?? 'Cérémonie officielle et réception conviviale avec famille et amis.',
    );
    _eventType = data['type'] ?? 'Mariage';
    _isPaid = data['isPaid'] ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    _feeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _isLoading = false);

      final updatedData = {
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'type': _eventType,
        'budgetInitial': '${_budgetController.text.trim()} FCFA',
        'isPaid': _isPaid,
        'fee': _isPaid ? '${_feeController.text.trim()} FCFA' : 'Gratuit',
        'description': _descriptionController.text.trim(),
      };

      Get.back(result: updatedData);
      Get.snackbar(
        'Succès',
        'Informations de la cérémonie mises à jour avec succès.',
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
        title: const Text(
          'Modifier la cérémonie',
          style: TextStyle(
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
              AppTextField(
                label: 'Nom de la cérémonie',
                controller: _titleController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 18),

              // Type de cérémonie
              const Text(
                'Type de cérémonie',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _eventType,
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _eventType = val);
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
              const SizedBox(height: 18),

              AppTextField(
                label: 'Lieu',
                controller: _locationController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 18),

              AppTextField(
                label: 'Budget prévisionnel (FCFA)',
                controller: _budgetController,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 18),

              // Conditions de participation
              const Text(
                'Conditions de participation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isPaid = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isPaid ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Gratuite',
                            style: TextStyle(
                              color: !_isPaid ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isPaid = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isPaid ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Payante',
                            style: TextStyle(
                              color: _isPaid ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              if (_isPaid) ...[
                AppTextField(
                  label: 'Montant de participation (FCFA)',
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  validator: (v) => (_isPaid && (v == null || v.trim().isEmpty)) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 18),
              ],

              AppTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              AppButton(
                label: 'Enregistrer les modifications',
                isLoading: _isLoading,
                onPressed: _saveChanges,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
