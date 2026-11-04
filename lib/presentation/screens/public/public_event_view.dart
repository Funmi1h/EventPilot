import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/data/models/event_model.dart';
import 'package:eventpilot/data/services/event_service.dart';
import 'package:eventpilot/data/models/participant_model.dart';
import 'package:eventpilot/data/services/participant_service.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';
import 'package:eventpilot/presentation/widgets/section_header.dart';
import 'package:eventpilot/presentation/screens/public/payment_simulation_view.dart';
import 'package:eventpilot/presentation/screens/public/registration_success_view.dart';

class PublicEventView extends StatefulWidget {
  final Map<String, dynamic>? eventData;

  const PublicEventView({super.key, this.eventData});

  @override
  State<PublicEventView> createState() => _PublicEventViewState();
}

class _PublicEventViewState extends State<PublicEventView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  EventModel? _event;
  bool _isLoading = false;
  bool _isPaid = false;
  String _fee = '0 FCFA';

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  //recuperer l'evenement depuis supabase via le parametre id
  Future<void> _loadEvent() async {
    String? eventId = Get.parameters['id'] ?? widget.eventData?['id']?.toString();
    if (eventId == null || eventId.isEmpty) {
      if (Uri.base.queryParameters.containsKey('id')) {
        eventId = Uri.base.queryParameters['id'];
      } else if (Uri.base.hasFragment) {
        final frag = Uri.base.fragment;
        if (frag.contains('?')) {
          final queryPart = frag.substring(frag.indexOf('?') + 1);
          final params = Uri.splitQueryString(queryPart);
          eventId = params['id'];
        }
      }
    }

    if (eventId != null && eventId.isNotEmpty) {
      try {
        setState(() => _isLoading = true);
        final ev = await EventService().getEventById(eventId);
        if (mounted) {
          setState(() {
            _event = ev;
            _isPaid = ev.isPaid;
            _fee = '${_formatAmount(ev.ticketPrice)} FCFA';
            _isLoading = false;
          });
        }
      } catch (_) {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (widget.eventData != null) {
      _isPaid = widget.eventData!['isPaid'] ?? true;
      _fee = widget.eventData!['fee'] ?? '15 000 FCFA';
    }
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  //afficher le formulaire d'inscription
  Future<void> _showRegistrationSheet() async {
    final sheetFormKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    final bool? proceed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 22,
              left: 24,
              right: 24,
              top: 12,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: sheetFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.borderStrong,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Inscription',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Renseignez vos coordonnées pour recevoir votre pass d\'accès.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      label: 'Nom complet',
                      hintText: 'Ex. Jean DUPONT',
                      prefixIcon: Icons.person_outline_rounded,
                      controller: _nameController,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Veuillez saisir votre nom'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Adresse e-mail',
                      hintText: 'jean.dupont@email.com',
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? 'E-mail valide requis' : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Téléphone',
                      hintText: '+229 97 00 00 00',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Numéro de téléphone requis'
                          : null,
                    ),
                    const SizedBox(height: 26),
                    AppButton(
                      label: _isPaid
                          ? 'Procéder au paiement ($_fee)'
                          : 'Confirmer mon inscription',
                      isLoading: isSubmitting,
                      onPressed: () async {
                        if (sheetFormKey.currentState?.validate() ?? false) {
                          setSheetState(() => isSubmitting = true);

                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();
                          final phone = _phoneController.text.trim();
                          final eventId = _event?.id ?? widget.eventData?['id']?.toString() ?? '';

                          if (eventId.isNotEmpty) {
                            try {
                              await ParticipantService().createParticipant(
                                ParticipantModel(
                                  eventId: eventId,
                                  fullName: name,
                                  email: email,
                                  phone: phone,
                                  registrationStatus: _isPaid ? 'pending' : 'confirmed',
                                ),
                              );
                            } catch (_) {}
                          }

                          if (ctx.mounted) {
                            Navigator.of(ctx).pop(true);
                          }
                        } else {
                          Get.snackbar(
                            'Champs requis',
                            'Veuillez remplir tous les champs obligatoires.',
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 4),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    if (proceed == true && mounted) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final eventTitle = _event?.name ?? widget.eventData?['title'] ?? 'Événement';

      if (_isPaid) {
        Get.to(() => PaymentSimulationView(
              participantName: name,
              participantEmail: email,
              participantPhone: phone,
              amount: _fee,
              eventTitle: eventTitle,
            ));
      } else {
        Get.to(() => RegistrationSuccessView(
              participantName: name,
              participantEmail: email,
              eventTitle: eventTitle,
              ticketCode: 'EP-FREE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
              isPaid: false,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.ink),
        ),
      );
    }

    final eventTitle = _event?.name ?? widget.eventData?['title'] ?? 'Événement';
    final eventType = _event?.type ?? widget.eventData?['type'] ?? 'Événement';
    final eventDate = _event != null
        ? '${_formatDate(_event!.date)} · ${_event!.time.replaceAll(':', 'h')}'
        : (widget.eventData?['date'] ?? 'Samedi 14 décembre 2026');
    final eventLocation = _event?.location.isNotEmpty == true
        ? _event!.location
        : (widget.eventData?['location'] ?? 'Lieu non défini');
    final eventDescription = _event?.description?.isNotEmpty == true
        ? _event!.description!
        : (widget.eventData?['description'] ??
            'Bienvenue sur la page d\'inscription de cet événement. Retrouvez ici toutes les informations pratiques.');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: AppColors.ink,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 21),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                color: AppColors.ink,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTag(
                      eventType,
                      dotColor: AppColors.accent,
                      emphasized: true,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      eventTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.7,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$eventDate · $eventLocation',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel('Informations pratiques'),
                  const SizedBox(height: 10),
                  _buildCustomInfoCard(eventDate, eventLocation),
                  const SizedBox(height: 20),
                  const SectionLabel('À propos'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      eventDescription,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    label: 'S\'inscrire à l\'événement',
                    onPressed: _showRegistrationSheet,
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      _isPaid
                          ? 'Participation de $_fee par personne'
                          : 'Entrée libre et gratuite',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomInfoCard(String dateStr, String locationStr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const AppIconBox(icon: Icons.calendar_today_outlined, size: 36, iconSize: 17),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  dateStr,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const AppIconBox(icon: Icons.place_outlined, size: 36, iconSize: 17),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  locationStr,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> event) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.calendar_today_outlined,
            title: 'Date & heure',
            subtitle: '${event['date']} · ${event['time']}',
          ),
          const Divider(height: 26),
          _buildInfoTile(
            icon: Icons.place_outlined,
            title: 'Lieu de réception',
            subtitle: event['location'] ?? 'Hôtel du Lac, Cotonou',
          ),
          const Divider(height: 26),
          _buildInfoTile(
            icon: Icons.confirmation_number_outlined,
            title: 'Participation',
            subtitle: _isPaid
                ? 'Événement payant par personne'
                : 'Entrée libre et gratuite',
            tag: _isPaid ? _fee : 'Gratuit',
            tagColor: _isPaid ? AppColors.accent : AppColors.success,
          ),
          const Divider(height: 26),
          _buildInfoTile(
            icon: Icons.person_outline_rounded,
            title: 'Organisé par',
            subtitle: event['organizer'] ?? 'Marc KOUASSI',
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Map<String, dynamic> event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        event['description'] ??
            'Nous serions ravis de partager ce moment unique en votre compagnie.',
        style: const TextStyle(
          fontSize: 13.5,
          color: AppColors.textSecondary,
          height: 1.65,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? tag,
    Color? tagColor,
  }) {
    return Row(
      children: [
        AppIconBox(icon: icon, size: 38, iconSize: 17),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 0.1,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (tag != null) ...[
          const SizedBox(width: 10),
          AppTag(tag, dotColor: tagColor),
        ],
      ],
    );
  }
}
