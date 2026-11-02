import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/screens/payments/payments_list_view.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';

class ParticipantsListView extends StatefulWidget {
  const ParticipantsListView({super.key});

  @override
  State<ParticipantsListView> createState() => _ParticipantsListViewState();
}

class _ParticipantsListViewState extends State<ParticipantsListView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Payé', 'En attente'];

  final List<Map<String, dynamic>> _participants = [
    {
      'id': '1',
      'name': 'Aurore DOSSOU',
      'email': 'aurore.dossou@gmail.com',
      'phone': '+229 97 12 34 56',
      'status': 'Payé',
      'amount': '15 000 FCFA',
      'date': 'Aujourd\'hui · 10h24',
      'initials': 'AD',
      'ticketCode': 'EP-MAR-001',
    },
    {
      'id': '2',
      'name': 'Fabrice HOUNKPÈ',
      'email': 'fabrice.hounkpe@yahoo.fr',
      'phone': '+229 96 45 87 12',
      'status': 'Payé',
      'amount': '15 000 FCFA',
      'date': 'Hier · 18h02',
      'initials': 'FH',
      'ticketCode': 'EP-MAR-002',
    },
    {
      'id': '3',
      'name': 'Nadège KPOSSOU',
      'email': 'nadege.kpossou@gmail.com',
      'phone': '+229 61 23 89 00',
      'status': 'Payé',
      'amount': '15 000 FCFA',
      'date': '20 oct. · 09h15',
      'initials': 'NK',
      'ticketCode': 'EP-MAR-003',
    },
    {
      'id': '4',
      'name': 'Brice AGBODJALOU',
      'email': 'brice.agbodjalou@hotmail.com',
      'phone': '+229 95 33 22 11',
      'status': 'En attente',
      'amount': '15 000 FCFA',
      'date': '19 oct. · 14h40',
      'initials': 'BA',
      'ticketCode': 'EP-MAR-004',
    },
    {
      'id': '5',
      'name': 'Christelle MENSAH',
      'email': 'c.mensah@gmail.com',
      'phone': '+229 97 88 55 44',
      'status': 'Payé',
      'amount': '15 000 FCFA',
      'date': '18 oct. · 16h20',
      'initials': 'CM',
      'ticketCode': 'EP-MAR-005',
    },
    {
      'id': '6',
      'name': 'Gildas TOSSOU',
      'email': 'gildas.tossou@outlook.com',
      'phone': '+229 62 10 20 30',
      'status': 'En attente',
      'amount': '15 000 FCFA',
      'date': '17 oct. · 11h05',
      'initials': 'GT',
      'ticketCode': 'EP-MAR-006',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showParticipantDetail(Map<String, dynamic> participant) {
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
                      participant['initials'],
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
                        participant['name'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        participant['ticketCode'],
                        style: const TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.4,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppTag(
                  participant['status'],
                  dotColor: participant['status'] == 'Payé'
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 18),
            _buildDetailRow(
              Icons.phone_outlined,
              'Téléphone',
              participant['phone'],
            ),
            const SizedBox(height: 14),
            _buildDetailRow(
              Icons.mail_outline_rounded,
              'E-mail',
              participant['email'],
            ),
            const SizedBox(height: 14),
            _buildDetailRow(
              Icons.confirmation_number_outlined,
              'Participation',
              participant['amount'],
            ),
            const SizedBox(height: 14),
            _buildDetailRow(
              Icons.schedule_rounded,
              'Inscription',
              participant['date'],
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Get.snackbar(
                        'Relance envoyée',
                        'Un rappel a été simulé vers ${participant['name']}.',
                      );
                    },
                    child: const Text('Relancer'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        participant['status'] =
                            participant['status'] == 'Payé'
                                ? 'En attente'
                                : 'Payé';
                      });
                      Navigator.pop(ctx);
                      Get.snackbar(
                        'Statut mis à jour',
                        '${participant['name']} · ${participant['status']}.',
                      );
                    },
                    child: Text(
                      participant['status'] == 'Payé'
                          ? 'Marquer en attente'
                          : 'Valider',
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
          p['name'].toString().toLowerCase().contains(query) ||
          p['email'].toString().toLowerCase().contains(query) ||
          p['phone'].toString().toLowerCase().contains(query);

      final matchesFilter = _selectedFilter == 'Tous' ||
          p['status'] == _selectedFilter;

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
                              onTap: () =>
                                  setState(() => _selectedFilter = f),
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 9),
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        final isPaid = p['status'] == 'Payé';

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
                                      p['initials'],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['name'],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${p['phone']} · ${p['date']}',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      p['amount'],
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    AppTag(
                                      p['status'],
                                      dotColor: isPaid
                                          ? AppColors.success
                                          : AppColors.warning,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                    ),
                                  ],
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
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildStat('70', 'Inscrits'),
          _buildDivider(),
          _buildStat('64', 'Confirmés'),
          _buildDivider(),
          _buildStat('6', 'En attente'),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.person_search_outlined,
              size: 21,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Aucun participant',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Essayez un autre nom ou filtre.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
