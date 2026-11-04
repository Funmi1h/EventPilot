import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/data/models/participant_model.dart';
import 'package:eventpilot/data/services/participant_service.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';
import 'package:eventpilot/presentation/screens/payments/payments_list_view.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';

class ParticipantsListView extends StatefulWidget {
  const ParticipantsListView({super.key});

  @override
  State<ParticipantsListView> createState() => _ParticipantsListViewState();
}

class _ParticipantsListViewState extends State<ParticipantsListView> {
  final ParticipantService _participantService = ParticipantService();
  final TextEditingController _searchController = TextEditingController();

  String _currentEventId = '';
  List<ParticipantModel> _participants = [];
  bool _isLoading = true;

  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Confirmé', 'En attente'];

  @override
  void initState() {
    super.initState();
    _initEventAndLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //determiner l'evenement courant et charger ses participants
  Future<void> _initEventAndLoad() async {
    if (Get.arguments is String && (Get.arguments as String).isNotEmpty) {
      _currentEventId = Get.arguments as String;
    } else if (Get.isRegistered<EventController>()) {
      _currentEventId = Get.find<EventController>().selectedEvent.value?.id ?? '';
    }

    if (_currentEventId.isNotEmpty) {
      await _loadParticipants();
    } else {
      setState(() => _isLoading = false);
    }
  }

  //recuperer les participants depuis supabase
  Future<void> _loadParticipants() async {
    try {
      setState(() => _isLoading = true);
      final list = await _participantService.getParticipantsByEvent(_currentEventId);
      if (mounted) {
        setState(() {
          _participants = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        Get.snackbar(
          'Erreur',
          'Impossible de charger les participants : $e',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  //mettre a jour le statut du participant
  Future<void> _toggleParticipantStatus(ParticipantModel participant) async {
    final newStatus = participant.registrationStatus == 'confirmed' ? 'pending' : 'confirmed';
    try {
      await _participantService.updateParticipantStatus(participant.id!, newStatus);
      setState(() {
        participant.registrationStatus = newStatus;
      });
      Get.snackbar(
        'Statut mis à jour',
        'Le statut de ${participant.fullName} est maintenant ${newStatus == 'confirmed' ? 'Confirmé' : 'En attente'}.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de modifier le statut : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }

  //formater la date en francais
  String _formatDate(DateTime? date) {
    if (date == null) return 'Récemment';
    const months = [
      '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    return '${date.day} ${months[date.month]} · ${date.hour.toString().padLeft(2, '0')}h${date.minute.toString().padLeft(2, '0')}';
  }

  void _showParticipantDetail(ParticipantModel participant) {
    final isConfirmed = participant.registrationStatus == 'confirmed' || participant.registrationStatus == 'Payé';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      participant.initials,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participant.fullName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        participant.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppTag(
                  isConfirmed ? 'Confirmé' : 'En attente',
                  dotColor: isConfirmed ? AppColors.success : AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 18),
            _buildDetailRow(
              Icons.phone_outlined,
              'Téléphone',
              participant.phone.isNotEmpty ? participant.phone : 'Non renseigné',
            ),
            const SizedBox(height: 14),
            _buildDetailRow(
              Icons.mail_outline_rounded,
              'E-mail',
              participant.email,
            ),
            const SizedBox(height: 14),
            _buildDetailRow(
              Icons.schedule_rounded,
              'Date d\'inscription',
              _formatDate(participant.createdAt),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Get.snackbar(
                        'Relance simulée',
                        'Un message de rappel a été préparé pour ${participant.fullName}.',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                      );
                    },
                    child: const Text('Relancer'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConfirmed ? AppColors.surfaceMuted : AppColors.ink,
                      foregroundColor: isConfirmed ? AppColors.textPrimary : Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _toggleParticipantStatus(participant);
                    },
                    child: Text(
                      isConfirmed ? 'Marquer en attente' : 'Confirmer',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase().trim();
    final filtered = _participants.where((p) {
      final matchesSearch = query.isEmpty ||
          p.fullName.toLowerCase().contains(query) ||
          p.email.toLowerCase().contains(query) ||
          p.phone.toLowerCase().contains(query);

      final isConfirmed = p.registrationStatus == 'confirmed' || p.registrationStatus == 'Payé';
      final matchesFilter = _selectedFilter == 'Tous' ||
          (_selectedFilter == 'Confirmé' && isConfirmed) ||
          (_selectedFilter == 'En attente' && !isConfirmed);

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.back(),
        ),
        title: const Text('Participants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.payments_outlined, size: 21),
            tooltip: 'Paiements',
            onPressed: () => Get.to(() => const PaymentsListView()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.ink))
            : RefreshIndicator(
                color: AppColors.ink,
                onRefresh: _loadParticipants,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
                      child: Column(
                        children: [
                          _buildStats(),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() {}),
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Rechercher un participant',
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                size: 19,
                                color: AppColors.textTertiary,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 16),
                                      color: AppColors.textTertiary,
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: AppColors.surfaceMuted,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 13,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.ink,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _filters.map((f) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 7),
                                    child: AppFilterChip(
                                      label: f,
                                      selected: _selectedFilter == f,
                                      onTap: () => setState(() => _selectedFilter = f),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(22, 2, 22, 28),
                              itemCount: filtered.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 9),
                              itemBuilder: (context, index) {
                                final p = filtered[index];
                                final isConfirmed = p.registrationStatus == 'confirmed' || p.registrationStatus == 'Payé';

                                return InkWell(
                                  onTap: () => _showParticipantDetail(p),
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: const BoxDecoration(
                                            color: AppColors.surfaceMuted,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              p.initials,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                p.fullName,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                '${p.phone.isNotEmpty ? p.phone : p.email} · ${_formatDate(p.createdAt)}',
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                  color: AppColors.textTertiary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AppTag(
                                          isConfirmed ? 'Confirmé' : 'En attente',
                                          dotColor: isConfirmed
                                              ? AppColors.success
                                              : AppColors.warning,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStats() {
    final total = _participants.length;
    final confirmed = _participants.where((p) => p.registrationStatus == 'confirmed' || p.registrationStatus == 'Payé').length;
    final pending = total - confirmed;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildStat('$total', 'Inscrits'),
          _buildDivider(),
          _buildStat('$confirmed', 'Confirmés'),
          _buildDivider(),
          _buildStat('$pending', 'En attente'),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 28, color: AppColors.border);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 24,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun participant enregistré',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Les personnes inscrites via le lien public de votre événement s\'afficheront directement ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
