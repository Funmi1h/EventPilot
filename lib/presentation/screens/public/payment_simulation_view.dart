import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/screens/public/registration_success_view.dart';

class PaymentSimulationView extends StatefulWidget {
  final String participantName;
  final String participantEmail;
  final String participantPhone;
  final String amount;
  final String eventTitle;

  const PaymentSimulationView({
    super.key,
    required this.participantName,
    required this.participantEmail,
    required this.participantPhone,
    required this.amount,
    required this.eventTitle,
  });

  @override
  State<PaymentSimulationView> createState() => _PaymentSimulationViewState();
}

class _PaymentSimulationViewState extends State<PaymentSimulationView> {
  String _selectedMethod = 'MTN Mobile Money';
  late TextEditingController _phoneOrCardController;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _methods = [
    {
      'id': 'MTN Mobile Money',
      'title': 'MTN MoMo (*880#)',
      'subtitle': 'Bénin · Simulation instantanée',
      'icon': Icons.phone_android_rounded,
      'color': Color(0xFFFFCC00),
      'textColor': Colors.black87,
    },
    {
      'id': 'Moov Money',
      'title': 'Moov Money (*855#)',
      'subtitle': 'Bénin · Simulation instantanée',
      'icon': Icons.mobile_friendly_rounded,
      'color': Color(0xFF005BAA),
      'textColor': Colors.white,
    },
    {
      'id': 'Carte bancaire',
      'title': 'Carte bancaire',
      'subtitle': 'Visa / Mastercard',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFF1E293B),
      'textColor': Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    _phoneOrCardController = TextEditingController(text: widget.participantPhone);
  }

  @override
  void dispose() {
    _phoneOrCardController.dispose();
    super.dispose();
  }

  void _processSimulatedPayment() async {
    setState(() => _isProcessing = true);

    // Simulation du flux USSD / Passerelle de paiement
    await Future.delayed(const Duration(milliseconds: 1400));

    setState(() => _isProcessing = false);

    Get.off(() => RegistrationSuccessView(
          participantName: widget.participantName,
          participantEmail: widget.participantEmail,
          eventTitle: widget.eventTitle,
          ticketCode: 'EP-PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          isPaid: true,
          amountPaid: widget.amount,
        ));
  }

  @override
  Widget build(BuildContext context) {
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
          'Simulation de paiement',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encart simulation avertissement ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.infoSoft,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 22),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Mode Simulation : Aucun débit réel ne sera effectué sur votre compte bancaire ou mobile.',
                      style: TextStyle(fontSize: 12, color: AppColors.info, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Récapitulatif du paiement ──
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Text(
                    'Montant à régler',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.amount,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow('Événement', widget.eventTitle),
                  _buildSummaryRow('Participant', widget.participantName),
                  _buildSummaryRow('E-mail', widget.participantEmail),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Choix du mode de règlement ──
            const Text(
              'Choisir le moyen de paiement simulé',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: _methods.map((method) {
                final isSelected = _selectedMethod == method['id'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMethod = method['id'];
                        if (method['id'] == 'Carte bancaire') {
                          _phoneOrCardController.text = '4000 1234 5678 9010';
                        } else {
                          _phoneOrCardController.text = widget.participantPhone;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: method['color'] as Color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              method['icon'] as IconData,
                              color: method['textColor'] as Color,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method['title'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  method['subtitle'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Radio<String>(
                            value: method['id'] as String,
                            groupValue: _selectedMethod,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedMethod = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Champ numéro / carte
            Text(
              _selectedMethod == 'Carte bancaire'
                  ? 'Numéro de carte (simulé)'
                  : 'Numéro Mobile Money pour confirmation',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneOrCardController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  _selectedMethod == 'Carte bancaire'
                      ? Icons.credit_card
                      : Icons.phone_android,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Bouton Valider ──
            AppButton(
              label: 'Valider le paiement simulé (${widget.amount})',
              isLoading: _isProcessing,
              icon: Icons.lock_outline_rounded,
              onPressed: _processSimulatedPayment,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
