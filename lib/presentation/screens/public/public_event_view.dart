import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPaid = true;
  final String _fee = '15 000 FCFA';

  @override
  void initState() {
    super.initState();
    if (widget.eventData != null) {
      _isPaid = widget.eventData!['isPaid'] ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showRegistrationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            key: _formKey,
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
                    fontSize: 17,
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.pop(ctx);
                      if (_isPaid) {
                        Get.to(() => PaymentSimulationView(
                              participantName: _nameController.text.trim(),
                              participantEmail: _emailController.text.trim(),
                              participantPhone: _phoneController.text.trim(),
                              amount: _fee,
                              eventTitle:
                                  widget.eventData?['title'] ?? 'Mariage Rita & Marc',
                            ));
                      } else {
                        Get.to(() => RegistrationSuccessView(
                              participantName: _nameController.text.trim(),
                              participantEmail: _emailController.text.trim(),
                              eventTitle:
                                  widget.eventData?['title'] ?? 'Mariage Rita & Marc',
                              ticketCode: 'EP-FREE-9921',
                              isPaid: false,
                            ));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.eventData ?? {
      'title': 'Mariage Rita & Marc',
      'type': 'Mariage',
      'date': 'Samedi 14 décembre 2026',
      'time': '15h00',
      'location': 'Hôtel du Lac, Cotonou, Bénin',
      'organizer': 'Marc KOUASSI',
      'description':
          'Nous avons la joie de vous convier à la célébration de notre mariage. La cérémonie religieuse sera suivie d\'un cocktail dinatoire et d\'une grande soirée dansante.',
    };

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
                      event['type'] ?? 'Cérémonie',
                      dotColor: AppColors.accent,
                      emphasized: true,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event['title'] ?? 'Mariage Rita & Marc',
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
                      '${event['date'] ?? ''} · ${event['location'] ?? ''}',
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
                  _buildCountdown(),
                  const SizedBox(height: 20),
                  const SectionLabel('Informations pratiques'),
                  const SizedBox(height: 10),
                  _buildInfoCard(event),
                  const SizedBox(height: 20),
                  const SectionLabel('À propos'),
                  const SizedBox(height: 10),
                  _buildDescription(event),
                  const SizedBox(height: 28),
                  AppButton(
                    label: 'S\'inscrire à la cérémonie',
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

  Widget _buildCountdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const AppIconBox(
            icon: Icons.event_available_outlined,
            size: 40,
            iconSize: 18,
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'J-53 avant le grand jour',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Les inscriptions sont ouvertes.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
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
