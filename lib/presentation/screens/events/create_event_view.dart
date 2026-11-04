import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';

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
  String? _typeEvenement = 'Mariage';
  DateTime? _selectedDate;
  String _selectedHeure = '15:00';

  final _budgetController = TextEditingController();
  final _montantController = TextEditingController();
  bool _isPayante = false;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _isSubmitting = false;

  static const List<String> _typesEvenement = [
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

  void _createEvent() async {
    if (_isSubmitting) return;

    if (_formKey2.currentState!.validate()) {
      if (_selectedDate == null) {
        _showMessage('Veuillez sélectionner une date.');
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        final budget = double.tryParse(
              _budgetController.text.trim().replaceAll(' ', '').replaceAll(',', '.'),
            ) ??
            0.0;
        final ticketPrice = _isPayante
            ? (double.tryParse(
                  _montantController.text.trim().replaceAll(' ', '').replaceAll(',', '.'),
                ) ??
                0.0)
            : 0.0;

        final controller = Get.isRegistered<EventController>()
            ? Get.find<EventController>()
            : Get.put(EventController());

        final success = await controller.addEvent(
          name: _nomController.text.trim(),
          type: _typeEvenement ?? 'Mariage',
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          date: _selectedDate!,
          time: _selectedHeure,
          location: _lieuController.text.trim(),
          budget: budget,
          isPaid: _isPayante,
          ticketPrice: ticketPrice,
        );

        if (success && mounted) {
          //fermeture de l'ecran et notification de succes
          Navigator.of(context).pop(true);
          Get.snackbar(
            'Succès',
            'Événement créé avec succès !',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  //indicateur pour les etapes
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

  //formulaire pour les informations de base
  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //en-tete de premiere etape avec titre et icone decorative
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Créer un événement',
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
                  Icons.celebration_outlined,
                  color: AppColors.ink,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          //champ pour le nom de l'evenement
          AppTextField(
            label: 'Nom de l\'événement',
            hintText: 'Ex. Mariage Rita & Marc',
            controller: _nomController,
            isUnderline: true,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 24),

          //selection du type d'evenement sous forme de pilules
          _buildDropdownField(),
          const SizedBox(height: 24),

          //champs de date et heure
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDateField()),
              const SizedBox(width: 16),
              Expanded(child: _buildHeureDropdown()),
            ],
          ),
          const SizedBox(height: 24),

          //champ pour le lieu
          AppTextField(
            label: 'Lieu',
            hintText: 'Ex. Hôtel du Lac, Cotonou',
            controller: _lieuController,
            isUnderline: true,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 24),

          //champ pour la description
          AppTextField(
            label: 'Description',
            hintText: 'Quelques mots sur l\'événement…',
            controller: _descriptionController,
            maxLines: 3,
            isUnderline: true,
          ),
          const SizedBox(height: 36),

          //bouton pour passer a l'etape suivante
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
          'Type d\'événement',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _typesEvenement.map((t) {
              final isSelected = _typeEvenement == t;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(t),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _typeEvenement = t),
                  selectedColor: AppColors.ink,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected ? AppColors.ink : AppColors.borderStrong,
                      width: 1.2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  showCheckmark: false,
                ),
              );
            }).toList(),
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
                  _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : 'jj/mm/aaaa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _selectedDate != null
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
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
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedHeure,
          onChanged: (v) => setState(() => _selectedHeure = v!),
          items: _heures
              .map((h) => DropdownMenuItem(value: h, child: Text(h)))
              .toList(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 8, top: 4),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderStrong, width: 1.4),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderStrong, width: 1.4),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.ink, width: 2.0),
            ),
          ),
          icon: const Icon(
            Icons.access_time_rounded,
            color: AppColors.ink,
            size: 20,
          ),
        ),
      ],
    );
  }

  //formulaire pour le budget et le type d'acces
  Widget _buildStep2() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //en-tete de seconde etape avec titre et icone decorative
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Budget & Accès',
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

          //champ pour le budget previsionnel
          AppTextField(
            label: 'Budget prévisionnel (FCFA)',
            hintText: 'Ex. 2 500 000',
            controller: _budgetController,
            keyboardType: TextInputType.number,
            isUnderline: true,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Ce champ est obligatoire'
                : null,
          ),
          const SizedBox(height: 24),

          //choix entre gratuit et payant
          _buildParticipationToggle(),
          const SizedBox(height: 24),

          if (_isPayante) ...[
            AppTextField(
              label: 'Montant de participation (FCFA)',
              hintText: 'Ex. 15 000',
              controller: _montantController,
              keyboardType: TextInputType.number,
              isUnderline: true,
              validator: (v) => (_isPayante && (v == null || v.trim().isEmpty))
                  ? 'Ce champ est obligatoire'
                  : null,
            ),
            const SizedBox(height: 24),
          ],
          _buildInfoBox(),
          const SizedBox(height: 24),
          _buildRecapitulatif(),
          const SizedBox(height: 36),

          //bouton pour finaliser la creation
          AppButton(
            label: 'Créer l\'événement',
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _createEvent,
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
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ChoiceChip(
              label: const Text('Gratuite'),
              selected: !_isPayante,
              onSelected: (_) => setState(() => _isPayante = false),
              selectedColor: AppColors.ink,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: !_isPayante ? FontWeight.w600 : FontWeight.w500,
                color: !_isPayante ? Colors.white : AppColors.textSecondary,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: !_isPayante ? AppColors.ink : AppColors.borderStrong,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              showCheckmark: false,
            ),
            const SizedBox(width: 10),
            ChoiceChip(
              label: const Text('Payante'),
              selected: _isPayante,
              onSelected: (_) => setState(() => _isPayante = true),
              selectedColor: AppColors.ink,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: _isPayante ? FontWeight.w600 : FontWeight.w500,
                color: _isPayante ? Colors.white : AppColors.textSecondary,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: _isPayante ? AppColors.ink : AppColors.borderStrong,
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              showCheckmark: false,
            ),
          ],
        ),
      ],
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
              'Un lien public unique sera généré pour partager l\'événement et recevoir les inscriptions.',
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
            'Événement',
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
        title: const Text('Nouvel événement'),
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
