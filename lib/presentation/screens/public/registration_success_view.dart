import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/utils/download_helper.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';

class RegistrationSuccessView extends StatefulWidget {
  final String? participantName;
  final String? participantEmail;
  final String? eventTitle;
  final String? ticketCode;
  final bool isPaid;
  final String? amountPaid;

  const RegistrationSuccessView({
    super.key,
    this.participantName,
    this.participantEmail,
    this.eventTitle,
    this.ticketCode,
    this.isPaid = false,
    this.amountPaid,
  });

  @override
  State<RegistrationSuccessView> createState() => _RegistrationSuccessViewState();
}

class _RegistrationSuccessViewState extends State<RegistrationSuccessView> {
  final GlobalKey _passKey = GlobalKey();
  final GlobalKey _qrKey = GlobalKey();
  bool _isDownloading = false;

  //telecharger le pass complet avec le qr code
  Future<void> _downloadPass() async {
    try {
      setState(() => _isDownloading = true);

      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _passKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Impossible de capturer le pass');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Erreur de conversion de l\'image');
      }

      final pngBytes = byteData.buffer.asUint8List();
      final code = widget.ticketCode ?? 'pass-invitation';
      downloadFile(pngBytes, '$code.png');

      Get.snackbar(
        'Pass téléchargé',
        'Le pass avec QR code a été enregistré.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger le pass : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  //telecharger uniquement le qr code
  Future<void> _downloadQrOnly() async {
    try {
      setState(() => _isDownloading = true);

      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Impossible de capturer le QR code');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Erreur de conversion de l\'image');
      }

      final pngBytes = byteData.buffer.asUint8List();
      final code = widget.ticketCode ?? 'qrcode';
      downloadFile(pngBytes, 'qrcode-$code.png');

      Get.snackbar(
        'QR Code téléchargé',
        'L\'image du QR code a été téléchargée avec succès.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger le QR code : $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.ink,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Inscription confirmée',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isPaid
                    ? 'Votre paiement de ${widget.amountPaid ?? "15 000 FCFA"} a été validé.'
                    : 'Votre place est bien enregistrée pour l\'événement.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 28),

              //carte du pass a capturer
              RepaintBoundary(
                key: _passKey,
                child: _buildPass(),
              ),
              const SizedBox(height: 26),

              AppButton(
                label: 'Enregistrer le pass',
                icon: Icons.download_outlined,
                isLoading: _isDownloading,
                onPressed: _downloadPass,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Retour',
                type: AppButtonType.outlined,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPass() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'PASS INVITATION',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    widget.ticketCode ?? 'EP-DEMO-001',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eventTitle ?? 'Mariage Rita & Marc',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sam. 14 déc. 2026 · 15h00\nHôtel du Lac, Cotonou',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _buildTicketInfo('Participant', widget.participantName ?? 'Invité'),
                const SizedBox(height: 10),
                _buildTicketInfo('E-mail', widget.participantEmail ?? '—'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Statut',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    AppTag(
                      widget.isPaid ? 'Payé & confirmé' : 'Entrée libre',
                      dotColor:
                          widget.isPaid ? AppColors.success : AppColors.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Center(
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: _qrKey,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 96,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Présentez ce QR code à l\'accueil',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextButton.icon(
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: const Text(
                          'Télécharger le QR code seul',
                          style: TextStyle(fontSize: 12, color: AppColors.ink),
                        ),
                        onPressed: _downloadQrOnly,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value) {
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
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
