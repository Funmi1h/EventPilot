import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/screens/payments/payments_list_view.dart';

class ParticipantsListView extends StatefulWidget {
  const ParticipantsListView({super.key});

  @override
  State<ParticipantsListView> createState() => _ParticipantsListViewState();
}

class _ParticipantsListViewState extends State<ParticipantsListView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Payé (64)', 'En attente (6)'];

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
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primarySoft,
                  child: Text(
                    participant['initials'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      fontSize: 18,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        participant['ticketCode'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: participant['status'] == 'Payé'
                        ? AppColors.successSoft
                        : AppColors.warningSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    participant['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: participant['status'] == 'Payé'
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow(Icons.phone_outlined, 'Téléphone', participant['phone']),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.email_outlined, 'Adresse e-mail', participant['email']),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.confirmation_number_outlined, 'Montant de participation', participant['amount']),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.access_time_rounded, 'Date d\'inscription', participant['date']),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Get.snackbar(
                        'Relance envoyée',
                        'Un rappel par SMS/Email a été simulé vers ${participant['name']}.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Relancer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        participant['status'] = participant['status'] == 'Payé' ? 'En attente' : 'Payé';
                      });
                      Navigator.pop(ctx);
                      Get.snackbar(
                        'Statut modifié',
                        'Le statut de ${participant['name']} est désormais : ${participant['status']}.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.successSoft,
                        colorText: AppColors.success,
                      );
                    },
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: Text(participant['status'] == 'Payé' ? 'Marquer attente' : 'Valider paiement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          '$label : ',
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
          (_selectedFilter.startsWith('Payé') && p['status'] == 'Payé') ||
          (_selectedFilter.startsWith('En attente') && p['status'] == 'En attente');

      return matchesSearch && matchesFilter;
    }).toList();

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
          'Participants',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.payments_outlined, color: AppColors.primaryDark),
            tooltip: 'Historique des paiements',
            onPressed: () {
              Get.to(() => const PaymentsListView());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── En-tête statistiques ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBadge('70', 'Inscrits au total', AppColors.primaryDark, AppColors.primarySoft),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatBadge('64', 'Payés / Confirmés', AppColors.success, AppColors.successSoft),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatBadge('6', 'En attente', AppColors.warning, AppColors.warningSoft),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Barre de recherche (3.5.3) ──
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un participant (nom, email, tel)...',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Onglets / Filtres ──
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((f) {
                        final isSel = _selectedFilter == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: isSel,
                            selectedColor: AppColors.primary,
                            backgroundColor: const Color(0xFFF3F4F6),
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              color: isSel ? Colors.white : AppColors.textSecondary,
                            ),
                            onSelected: (val) {
                              setState(() => _selectedFilter = f);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Liste des participants (3.5.2) ──
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_outlined, size: 54, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 10),
                          const Text(
                            'Aucun participant correspondant',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        final isPaid = p['status'] == 'Payé';

                        return InkWell(
                          onTap: () => _showParticipantDetail(p),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: isPaid ? const Color(0xFFEEF2FF) : AppColors.warningSoft,
                                  child: Text(
                                    p['initials'],
                                    style: TextStyle(
                                      color: isPaid ? Colors.indigo : AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${p['phone']} · ${p['date']}',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      p['amount'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isPaid ? AppColors.successSoft : AppColors.warningSoft,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        p['status'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isPaid ? AppColors.success : AppColors.warning,
                                        ),
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

  Widget _buildStatBadge(String count, String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
