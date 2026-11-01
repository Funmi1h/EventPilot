import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/views/shared/app_button.dart';
import 'package:eventpilot/views/shared/app_text_field.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  int _currentStep = 0;

  // Contrôleurs — étape 1
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lieuController = TextEditingController();
  String? _typeCeremonie = 'Mariage';
  DateTime? _selectedDate;
  String _selectedHeure = '15:00';

  // Contrôleurs — étape 2
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

  void _goToStep2() {
    if (_formKey1.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner une date.')),
        );
        return;
      }
      setState(() => _currentStep = 1);
    }
  }

  void _createEvent() {
    if (_formKey2.currentState!.validate()) {
      // TODO: logique de création / appel API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Événement créé avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  // ─────────────────────────────────────────
  // Widgets de l'indicateur de progression
  // ─────────────────────────────────────────

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStepCircle(0, 'Informations'),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep >= 1 ? AppColors.success : AppColors.border,
            ),
          ),
          _buildStepCircle(1, 'Budget & accès'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final bool isCompleted = _currentStep > step;
    final bool isActive = _currentStep == step;

    Color circleColor;
    Widget circleChild;

    if (isCompleted) {
      circleColor = AppColors.success;
      circleChild = const Icon(Icons.check, color: Colors.white, size: 16);
    } else if (isActive) {
      circleColor = AppColors.primary;
      circleChild = Text(
        '${step + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      circleColor = AppColors.border;
      circleChild = Text(
        '${step + 1}',
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: circleChild,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // Étape 1 : Informations
  // ─────────────────────────────────────────

  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nom de la cérémonie
          AppTextField(
            label: 'Nom de la cérémonie',
            hintText: 'Ex : Mariage Rita & Marc',
            controller: _nomController,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 20),

          // Type de cérémonie
          _buildDropdownField(),
          const SizedBox(height: 20),

          // Description
          AppTextField(
            label: 'Description',
            hintText: 'Décrivez votre événement…',
            controller: _descriptionController,
            maxLines: 3,
          ),
          const SizedBox(height: 20),

          // Date + Heure
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDateField()),
              const SizedBox(width: 12),
              Expanded(child: _buildHeureDropdown()),
            ],
          ),
          const SizedBox(height: 20),

          // Lieu
          AppTextField(
            label: 'Lieu',
            hintText: 'Ex : Hôtel du Lac, Cotonou',
            controller: _lieuController,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 32),

          // Bouton Continuer
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
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
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
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
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
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
            color: AppColors.textSecondary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // Étape 2 : Budget & accès
  // ─────────────────────────────────────────

  Widget _buildStep2() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget
          AppTextField(
            label: 'Budget prévisionnel (FCFA)',
            hintText: 'Ex : 2 500 000',
            controller: _budgetController,
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 20),

          // Toggle Gratuite / Payante
          _buildParticipationToggle(),
          const SizedBox(height: 20),

          // Montant (affiché uniquement si Payante)
          if (_isPayante) ...[
            AppTextField(
              label: 'Montant de participation (FCFA)',
              hintText: 'Ex : 15 000',
              controller: _montantController,
              keyboardType: TextInputType.number,
              validator: (v) => (_isPayante && (v == null || v.trim().isEmpty))
                  ? 'Ce champ est obligatoire'
                  : null,
            ),
            const SizedBox(height: 20),
          ],

          // Info lien public
          _buildInfoBox(),
          const SizedBox(height: 20),

          // Récapitulatif
          _buildRecapitulatif(),
          const SizedBox(height: 32),

          // Bouton Créer
          AppButton(label: "Créer l'événement", onPressed: _createEvent),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.border,
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
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.link_rounded, color: AppColors.success, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Un lien public unique sera généré pour partager la cérémonie et recevoir les inscriptions.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.success.withValues(alpha: 0.9),
                height: 1.4,
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
      padding: const EdgeInsets.all(16),
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
              fontSize: 15,
              fontWeight: FontWeight.bold,
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
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Build principal
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Nouvel événement',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(color: AppColors.surface, child: _buildStepIndicator()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _currentStep == 0
                    ? KeyedSubtree(key: const ValueKey(0), child: _buildStep1())
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
