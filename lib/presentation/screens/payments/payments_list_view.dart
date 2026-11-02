import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';

class PaymentsListView extends StatefulWidget {
  const PaymentsListView({super.key});

  @override
  State<PaymentsListView> createState() => _PaymentsListViewState();
}

class _PaymentsListViewState extends State<PaymentsListView> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Réussis', 'En attente'];

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
    final isSuccess = payment['status'] == 'Réussi';

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Reçu de transaction',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: AppColors.textTertiary,
                    onPressed: () => Navigator.pop(ctx),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 22),
              Center(
                child: Column(
                  children: [
                    Text(
                      '${_formatAmount(payment['amount'])} FCFA',
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTag(
                      'Paiement ${payment['status'].toString().toLowerCase()}',
                      dotColor: isSuccess
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildReceiptRow('Participant', payment['participant']),
              const SizedBox(height: 10),
              _buildReceiptRow('Moyen de paiement', payment['method']),
              const SizedBox(height: 10),
              _buildReceiptRow('Date & heure', payment['date']),
              const SizedBox(height: 10),
              _buildReceiptRow('Référence', payment['reference']),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Transaction enregistrée via le simulateur de paiement EventPilot.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
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
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _payments.where((p) {
      if (_selectedFilter == 'Réussis') return p['status'] == 'Réussi';
      if (_selectedFilter == 'En attente') return p['status'] == 'En attente';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 21),
          onPressed: () => Get.back(),
        ),
        title: const Text('Paiements'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
              child: Column(
                children: [
                  _buildTotalCard(),
                  const SizedBox(height: 14),
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
                        final isSuccess = p['status'] == 'Réussi';

                        return InkWell(
                          onTap: () => _showReceiptDialog(p),
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
                                AppIconBox(
                                  icon: isSuccess
                                      ? Icons.check_rounded
                                      : Icons.schedule_rounded,
                                  size: 38,
                                  iconSize: 17,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['participant'],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${p['method']} · ${p['date']}',
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
                                      '+ ${_formatAmount(p['amount'])} F',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    AppTag(
                                      p['status'],
                                      dotColor: isSuccess
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

  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Montant total collecté',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '960 000 FCFA',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.8,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const _StatusDot(color: AppColors.success),
              const SizedBox(width: 7),
              const Text(
                '64 réussis',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 16),
              const _StatusDot(color: AppColors.warning),
              const SizedBox(width: 7),
              const Text(
                '6 en attente',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              Icons.receipt_long_outlined,
              size: 21,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Aucun paiement',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Aucune transaction ne correspond à ce filtre.',
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

class _StatusDot extends StatelessWidget {
  final Color color;

  const _StatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
