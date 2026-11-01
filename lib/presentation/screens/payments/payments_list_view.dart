import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';

class PaymentsListView extends StatefulWidget {
  const PaymentsListView({super.key});

  @override
  State<PaymentsListView> createState() => _PaymentsListViewState();
}

class _PaymentsListViewState extends State<PaymentsListView> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Réussis (64)', 'En attente (6)'];

  final List<Map<String, dynamic>> _payments = [
    {
      'id': 'PAY-9081',
      'participant': 'Aurore DOSSOU',
      'amount': 15000,
      'status': 'Réussi',
      'method': 'MTN Mobile Money',
      'date': '01 nov. 2026 à 10h24',
      'reference': 'TXN-BJ-20261101-8842',
    },
    {
      'id': 'PAY-9080',
      'participant': 'Fabrice HOUNKPÈ',
      'amount': 15000,
      'status': 'Réussi',
      'method': 'Moov Money',
      'date': '31 oct. 2026 à 18h02',
      'reference': 'TXN-BJ-20261031-7719',
    },
    {
      'id': 'PAY-9079',
      'participant': 'Nadège KPOSSOU',
      'amount': 15000,
      'status': 'Réussi',
      'method': 'Carte bancaire (Visa)',
      'date': '20 oct. 2026 à 09h15',
      'reference': 'TXN-BJ-20261020-6501',
    },
    {
      'id': 'PAY-9078',
      'participant': 'Brice AGBODJALOU',
      'amount': 15000,
      'status': 'En attente',
      'method': 'MTN Mobile Money',
      'date': '19 oct. 2026 à 14h40',
      'reference': 'TXN-BJ-20261019-5412',
    },
    {
      'id': 'PAY-9077',
      'participant': 'Christelle MENSAH',
      'amount': 15000,
      'status': 'Réussi',
      'method': 'MTN Mobile Money',
      'date': '18 oct. 2026 à 16h20',
      'reference': 'TXN-BJ-20261018-4390',
    },
    {
      'id': 'PAY-9076',
      'participant': 'Gildas TOSSOU',
      'amount': 15000,
      'status': 'En attente',
      'method': 'Moov Money',
      'date': '17 oct. 2026 à 11h05',
      'reference': 'TXN-BJ-20261017-3281',
    },
  ];

  String _formatAmount(num amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  void _showReceiptDialog(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reçu de transaction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    '${_formatAmount(payment['amount'])} FCFA',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: payment['status'] == 'Réussi' ? AppColors.successSoft : AppColors.warningSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Paiement ${payment['status']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: payment['status'] == 'Réussi' ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildReceiptRow('Participant', payment['participant']),
            _buildReceiptRow('Moyen de paiement', payment['method']),
            _buildReceiptRow('Date & Heure', payment['date']),
            _buildReceiptRow('Référence', payment['reference']),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Transaction enregistrée via le simulateur de paiement EventPilot.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _payments.where((p) {
      if (_selectedFilter.startsWith('Réussis')) return p['status'] == 'Réussi';
      if (_selectedFilter.startsWith('En attente')) return p['status'] == 'En attente';
      return true;
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
          'Historique des paiements',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Bannière total collecté (3.6.6) ──
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16A34A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Montant total collecté',
                                style: TextStyle(
                                  color: Color(0xFF16A34A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '960 000 FCFA',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '64 paiements réussis · 6 en attente',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Filtres ──
                  Row(
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
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Liste des transactions (3.6.4 & 3.6.5) ──
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final p = filtered[index];
                  final isSuccess = p['status'] == 'Réussi';

                  return InkWell(
                    onTap: () => _showReceiptDialog(p),
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
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: isSuccess ? AppColors.successSoft : AppColors.warningSoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isSuccess ? Icons.check_circle_outline : Icons.pending_outlined,
                              color: isSuccess ? AppColors.success : AppColors.warning,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['participant'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${p['method']} · ${p['date']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '+ ${_formatAmount(p['amount'])} F',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isSuccess ? AppColors.success : AppColors.warning,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                p['status'],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSuccess ? AppColors.success : AppColors.warning,
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
}
