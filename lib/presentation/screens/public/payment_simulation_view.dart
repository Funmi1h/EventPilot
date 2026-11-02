import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/app_text_field.dart';
import 'package:eventpilot/presentation/widgets/section_header.dart';
import 'package:eventpilot/presentation/screens/public/registration_success_view.dart';

class PaymentSimulationView extends StatefulWidget {
  final String? participantName;
  final String? participantEmail;
  final String? participantPhone;
  final String? amount;
  final String? eventTitle;

  const PaymentSimulationView({
    super.key,
    this.participantName,
    this.participantEmail,
    this.participantPhone,
    this.amount,
    this.eventTitle,
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
      'title': 'MTN Mobile Money',
      'subtitle': '*880# · Bénin',
      'icon': Icons.phone_android_rounded,
    },
    {
      'id': 'Moov Money',
      'title': 'Moov Money',
      'subtitle': '*855# · Bénin',
      'icon': Icons.mobile_friendly_rounded,
    },
    {
      'id': 'Carte bancaire',
      'title': 'Carte bancaire',
      'subtitle': 'Visa · Mastercard',
      'icon': Icons.credit_card_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    final phone = widget.participantPhone ?? args?['participantPhone'] ?? '';
    _phoneOrCardController = TextEditingController(text: phone);
  }

  String get _name =>
      widget.participantName ??
      (Get.arguments as Map<String, dynamic>?)?['participantName'] ??
      'Invité';
  String get _email =>
      widget.participantEmail ??
      (Get.arguments as Map<String, dynamic>?)?['participantEmail'] ??
      '';
  String get _amount =>
      widget.amount ??
      (Get.arguments as Map<String, dynamic>?)?['amount'] ??
      '15 000 FCFA';
  String get _eventTitle =>
      widget.eventTitle ??
      (Get.arguments as Map<String, dynamic>?)?['eventTitle'] ??
      'Mariage Rita & Marc';

  @override
  void dispose() {
    _phoneOrCardController.dispose();
    super.dispose();
  }

  void _processSimulatedPayment() async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(milliseconds: 1400));

    setState(() => _isProcessing = false);

    Get.off(() => RegistrationSuccessView(
          participantName: _name,
          participantEmail: _email,
          eventTitle: _eventTitle,
          ticketCode:
              'EP-PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          isPaid: true,
          amountPaid: _amount,
        ));
  }

  void _selectMethod(String id) {
    setState(() {
      _selectedMethod = id;
      if (id == 'Carte bancaire') {
        _phoneOrCardController.text = '4000 1234 5678 9010';
      } else {
        _phoneOrCardController.text = '';
      }
    });
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
        title: const Text('Paiement'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotice(),
              const SizedBox(height: 16),
              _buildSummary(),
              const SizedBox(height: 24),
              const SectionLabel('Moyen de paiement'),
              const SizedBox(height: 10),
              ..._methods.map(_buildMethodTile),
              const SizedBox(height: 20),
              AppTextField(
                label: _selectedMethod == 'Carte bancaire'
                    ? 'Numéro de carte (simulé)'
                    : 'Numéro Mobile Money',
                hintText: _selectedMethod == 'Carte bancaire'
                    ? '4000 1234 5678 9010'
                    : '+229 97 00 00 00',
                prefixIcon: _selectedMethod == 'Carte bancaire'
                    ? Icons.credit_card_rounded
                    : Icons.phone_android_rounded,
                keyboardType: TextInputType.number,
                controller: _phoneOrCardController,
              ),
              const SizedBox(height: 26),
              AppButton(
                label: 'Valider le paiement ($_amount)',
                isLoading: _isProcessing,
                icon: Icons.lock_outline_rounded,
                onPressed: _processSimulatedPayment,
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Aucun débit réel ne sera effectué.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.textSecondary,
            size: 18,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Mode simulation. Aucun débit réel ne sera effectué sur votre compte.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Montant à régler',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              AppTag('Simulation', dotColor: AppColors.accent),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _amount,
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.9,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildSummaryRow('Événement', _eventTitle),
          const SizedBox(height: 9),
          _buildSummaryRow('Participant', _name),
          if (_email.isNotEmpty) ...[
            const SizedBox(height: 9),
            _buildSummaryRow('E-mail', _email),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodTile(Map<String, dynamic> method) {
    final isSelected = _selectedMethod == method['id'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: InkWell(
        onTap: () => _selectMethod(method['id'] as String),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.ink : AppColors.border,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              AppIconBox(
                icon: method['icon'] as IconData,
                size: 38,
                iconSize: 17,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['title'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      method['subtitle'] as String,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ink : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.ink : AppColors.borderStrong,
                    width: 1.2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 11, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
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
    );
  }
}
