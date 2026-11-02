import 'package:flutter/material.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  int _currentStep = 0;

  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lieuController = TextEditingController();
  String? _typeCeremonie = 'Mariage';
  DateTime? _selectedDate;
  String _selectedHeure = '15:00';

  final _budgetController = TextEditingController();
  final _montantController = TextEditingController();
  bool _isPayante = false;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  static const List<String> _typesCeremonie = [
    'Mariage',
    'Baptême',
    'Anniversaire',
    'Conférence',
    'Soirée',
    'Autre',
  ];

  static const List<String> _heures = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _lieuController.dispose();
    _budgetController.dispose();
    _montantController.dispose();
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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
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

  void _goToStep2() {
    if (_formKey1.currentState!.validate()) {
      if (_selectedDate == null) {
        _showMessage('Veuillez sélectionner une date.');
        return;
      }
      setState(() => _currentStep = 1);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _createEvent() {
    if (_formKey2.currentState!.validate()) {
      _showMessage('Cérémonie créée.');
      Navigator.of(context).pop();
    }
  }

  // ── Indicateur d'étapes ──

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
      child: Row(
        children: [
          _buildStepLabel(0, 'Informations'),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: _currentStep >= 1
                  ? AppColors.ink
                  : AppColors.border,
            ),
          ),
          _buildStepLabel(1, 'Budget & accès'),
        ],
      ),
    );
  }

  Widget _buildStepLabel(int step, String label) {
    final bool isActive = _currentStep == step;
    final bool isDone = _currentStep > step;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive || isDone ? AppColors.ink : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isDone
                  ? AppColors.ink
                  : AppColors.borderStrong,
            ),
          ),
          child: isDone
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : Text(
                  '${step + 1}',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textTertiary,
                  ),
                ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  // ── Étape 1 ──

  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Nom de la cérémonie',
            hintText: 'Ex. Mariage Rita & Marc',
            controller: _nomController,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 18),
          _buildDropdownField(),
          const SizedBox(height: 18),
          AppTextField(
            label: 'Description',
            hintText: 'Quelques mots sur l\'événement…',
            controller: _descriptionController,
            maxLines: 3,
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDateField()),
              const SizedBox(width: 12),
              Expanded(child: _buildHeureDropdown()),
            ],
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'Lieu',
            hintText: 'Ex. Hôtel du Lac, Cotonou',
            controller: _lieuController,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 30),
          AppButton(label: 'Continuer', onPressed: _goToStep2),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type de cérémonie',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _typeCeremonie,
          onChanged: (v) => setState(() => _typeCeremonie = v),
          validator: (v) => v == null ? 'Veuillez choisir un type' : null,
          items: _typesCeremonie
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          style: const TextStyle(fontSize: 14.5, color: AppColors.textPrimary),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
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
              children: [
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : 'jj/mm/aaaa',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
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
      ],
    );
  }

  Widget _buildHeureDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Heure',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedHeure,
          onChanged: (v) => setState(() => _selectedHeure = v!),
          items: _heures
              .map((h) => DropdownMenuItem(value: h, child: Text(h)))
              .toList(),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ── Étape 2 ──

  Widget _buildStep2() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Budget prévisionnel (FCFA)',
            hintText: 'Ex. 2 500 000',
            controller: _budgetController,
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 20),
          _buildParticipationToggle(),
          const SizedBox(height: 20),
          if (_isPayante) ...[
            AppTextField(
              label: 'Montant de participation (FCFA)',
              hintText: 'Ex. 15 000',
              controller: _montantController,
              keyboardType: TextInputType.number,
              validator: (v) => (_isPayante && (v == null || v.trim().isEmpty))
                  ? 'Ce champ est obligatoire'
                  : null,
            ),
            const SizedBox(height: 20),
          ],
          _buildInfoBox(),
          const SizedBox(height: 20),
          _buildRecapitulatif(),
          const SizedBox(height: 30),
          AppButton(
            label: 'Créer la cérémonie',
            onPressed: _createEvent,
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conditions de participation',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildToggleOption('Gratuite', !_isPayante),
              _buildToggleOption('Payante', _isPayante),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isPayante = label == 'Payante'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.ink : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.link_rounded, color: AppColors.accent, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Un lien public unique sera généré pour partager la cérémonie et recevoir les inscriptions.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecapitulatif() {
    final String dateStr = _selectedDate != null
        ? '${_formatDate(_selectedDate!)} · ${_selectedHeure.replaceAll(':', 'h')}'
        : '—';
    final String budget = _budgetController.text.trim().isEmpty
        ? '—'
        : '${_budgetController.text.trim()} FCFA';
    final String participation = !_isPayante
        ? 'Gratuite'
        : (_montantController.text.trim().isEmpty
              ? '—'
              : '${_montantController.text.trim()} FCFA');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Récapitulatif',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildRecapRow(
            'Cérémonie',
            _nomController.text.trim().isEmpty
                ? '—'
                : _nomController.text.trim(),
          ),
          _buildRecapRow('Date', dateStr),
          _buildRecapRow('Budget', budget),
          _buildRecapRow('Participation', participation),
        ],
      ),
    );
  }

  Widget _buildRecapRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text('Nouvelle cérémonie'),
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _currentStep == 0
                    ? KeyedSubtree(
                        key: const ValueKey(0),
                        child: _buildStep1(),
                      )
                    : KeyedSubtree(
                        key: const ValueKey(1),
                        child: _buildStep2(),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
