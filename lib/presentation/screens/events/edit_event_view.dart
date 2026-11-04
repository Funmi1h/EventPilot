import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/data/models/event_model.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';

class EditEventView extends StatefulWidget {
  final EventModel? event;
  final Map<String, dynamic>? eventData;

  const EditEventView({super.key, this.event, this.eventData});

  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  //le controller pour sauvegarder les modifications dans supabase
  final EventController _controller = Get.isRegistered<EventController>()
      ? Get.find<EventController>()
      : Get.put(EventController());

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _budgetController;
  late TextEditingController _feeController;
  late TextEditingController _descriptionController;
  late String _eventType;
  late bool _isPaid;
  bool _isLoading = false;
  EventModel? _event;

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
    //on recupere l'evenement reel
    if (widget.event != null) {
      _event = widget.event;
    } else if (Get.arguments is EventModel) {
      _event = Get.arguments as EventModel;
    }

    final title = _event?.name ?? widget.eventData?['title'] ?? '';
    final loc = _event?.location ?? widget.eventData?['location'] ?? '';
    final budgetVal = _event != null
        ? _event!.budget.toInt().toString()
        : (widget.eventData?['budgetInitial'] ?? '0').toString().replaceAll(' FCFA', '').replaceAll(' ', '');
    final feeVal = _event != null
        ? _event!.ticketPrice.toInt().toString()
        : (widget.eventData?['fee'] ?? '0').toString().replaceAll(' FCFA', '').replaceAll(' ', '');
    final desc = _event?.description ?? widget.eventData?['description'] ?? '';

    _titleController = TextEditingController(text: title);
    _locationController = TextEditingController(text: loc);
    _budgetController = TextEditingController(text: budgetVal);
    _feeController = TextEditingController(text: feeVal);
    _descriptionController = TextEditingController(text: desc);
    _eventType = _event?.type ?? widget.eventData?['type'] ?? 'Mariage';
    _isPaid = _event?.isPaid ?? widget.eventData?['isPaid'] ?? false;
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

  //enregistrer les modifications de l'evenement
  void _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final eventId = _event?.id ?? widget.eventData?['id'];
      if (eventId == null) {
        setState(() => _isLoading = false);
        Get.snackbar(
          'Erreur',
          'Identifiant de l\'événement introuvable.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
        return;
      }

      final budget = double.tryParse(_budgetController.text.trim()) ?? 0.0;
      final fee = _isPaid
          ? (double.tryParse(_feeController.text.trim()) ?? 0.0)
          : 0.0;

      final success = await _controller.updateEventDetails(
        eventId: eventId,
        name: _titleController.text.trim(),
        type: _eventType,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        location: _locationController.text.trim(),
        budget: budget,
        isPaid: _isPaid,
        ticketPrice: fee,
      );

      setState(() => _isLoading = false);

      if (success) {
        Get.back(result: true); //on retourne avec succes
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
        title: const Text('Modifier l\'événement'),
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
                    'Modifier l\'événement',
                    style: TextStyle(
                      fontSize: 22,
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
                      Icons.edit_calendar_rounded,
                      color: AppColors.ink,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              //nom de l'evenement
              AppTextField(
                label: 'Nom de l\'événement',
                controller: _titleController,
                isUnderline: true,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),
              const SizedBox(height: 24),

              //selection du type d'evenement sous forme de pilules
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
                  children: _types.map((t) {
                    final isSelected = _eventType == t;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _eventType = t),
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
              const SizedBox(height: 24),

              //lieu
              AppTextField(
                label: 'Lieu',
                controller: _locationController,
                isUnderline: true,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),
              const SizedBox(height: 24),

              //budget previsionnel
              AppTextField(
                label: 'Budget prévisionnel (FCFA)',
                controller: _budgetController,
                keyboardType: TextInputType.number,
                isUnderline: true,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Champ requis'
                    : null,
              ),
              const SizedBox(height: 24),

              //conditions de participation
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
                    selected: !_isPaid,
                    onSelected: (_) => setState(() => _isPaid = false),
                    selectedColor: AppColors.ink,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: !_isPaid ? FontWeight.w600 : FontWeight.w500,
                      color: !_isPaid ? Colors.white : AppColors.textSecondary,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: !_isPaid ? AppColors.ink : AppColors.borderStrong,
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    showCheckmark: false,
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Payante'),
                    selected: _isPaid,
                    onSelected: (_) => setState(() => _isPaid = true),
                    selectedColor: AppColors.ink,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: _isPaid ? FontWeight.w600 : FontWeight.w500,
                      color: _isPaid ? Colors.white : AppColors.textSecondary,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: _isPaid ? AppColors.ink : AppColors.borderStrong,
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    showCheckmark: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (_isPaid) ...[
                AppTextField(
                  label: 'Montant de participation (FCFA)',
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  isUnderline: true,
                  validator: (v) =>
                      (_isPaid && (v == null || v.trim().isEmpty))
                          ? 'Champ requis'
                          : null,
                ),
                const SizedBox(height: 24),
              ],

              //description
              AppTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 3,
                isUnderline: true,
              ),
              const SizedBox(height: 36),

              AppButton(
                label: 'Enregistrer les modifications',
                isLoading: _isLoading,
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
