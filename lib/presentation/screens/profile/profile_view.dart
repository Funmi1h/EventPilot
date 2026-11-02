import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/screens/public/public_event_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _fullName = 'Marc KOUASSI';
  final String _email = 'organisateur@eventpilot.bj';
  String _phone = '+229 97 00 11 22';
  final String _role = 'Organisateur';

  String get _initials {
    if (_fullName.isEmpty) return 'EP';
    return _fullName
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join();
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _fullName);
    final phoneCtrl = TextEditingController(text: _phone);

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
                const Expanded(
                  child: Text(
                    'Modifier mon profil',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 19),
                  color: AppColors.textTertiary,
                  onPressed: () => Navigator.pop(ctx),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 22),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(labelText: 'Nom complet'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(labelText: 'Téléphone'),
            ),
            const SizedBox(height: 26),
            AppButton(
              label: 'Enregistrer les modifications',
              onPressed: () {
                setState(() {
                  _fullName = nameCtrl.text.trim();
                  _phone = phoneCtrl.text.trim();
                });
                Navigator.pop(ctx);
                Get.snackbar('Profil mis à jour', 'Vos informations ont été enregistrées.');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Déconnexion',
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      middleText: 'Voulez-vous fermer votre session ?',
      middleTextStyle: const TextStyle(
        fontSize: 13,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      textConfirm: 'Se déconnecter',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.ink,
      cancelTextColor: AppColors.textSecondary,
      onConfirm: () {
        Get.back();
        Get.offAllNamed(AppRoutes.HOME);
        Get.snackbar('Déconnecté', 'Votre session a été fermée.');
      },
    );
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
        title: const Text('Mon profil'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 30),
          child: Column(
            children: [
              _buildProfileCard(),
              const SizedBox(height: 16),
              _buildStats(),
              const SizedBox(height: 16),
              _buildMenu(),
              const SizedBox(height: 16),
              _buildLogout(),
              const SizedBox(height: 26),
              const Text(
                'EventPilot v1.0.0 · IFRI UAC GL3',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showEditProfileDialog,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _fullName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _email,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _phone,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 14),
          AppTag(_role, dotColor: AppColors.accent),
        ],
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
          _buildStat('3', 'Cérémonies'),
          _buildStatDivider(),
          _buildStat('142', 'Invités'),
          _buildStatDivider(),
          _buildStat('92 %', 'Succès'),
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
              fontSize: 19,
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

  Widget _buildStatDivider() {
    return Container(width: 1, height: 28, color: AppColors.border);
  }

  Widget _buildMenu() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.person_outline_rounded,
            title: 'Modifier mes informations',
            subtitle: 'Nom, téléphone, coordonnées',
            onTap: _showEditProfileDialog,
          ),
          const Divider(height: 1, indent: 60),
          _buildListTile(
            icon: Icons.open_in_new_rounded,
            title: 'Page publique invité',
            subtitle: 'Tester l\'expérience participant',
            onTap: () => Get.to(() => const PublicEventView()),
          ),
          const Divider(height: 1, indent: 60),
          _buildListTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Rappels d\'échéance, alertes budget',
            onTap: () {
              Get.snackbar(
                'Notifications activées',
                'Vous recevrez les rappels et alertes budgétaires.',
              );
            },
          ),
          const Divider(height: 1, indent: 60),
          _buildListTile(
            icon: Icons.lock_outline_rounded,
            title: 'Sécurité',
            subtitle: 'Mot de passe et accès',
            onTap: () {
              Get.snackbar(
                'Sécurité',
                'Votre compte est sécurisé par Supabase Auth.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: _buildListTile(
        icon: Icons.logout_rounded,
        iconColor: AppColors.error,
        title: 'Déconnexion',
        subtitle: 'Fermer votre session',
        onTap: _confirmLogout,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: AppIconBox(
        icon: icon,
        size: 38,
        iconSize: 18,
        color: iconColor ?? AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11.5,
            color: AppColors.textTertiary,
          ),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiary,
        size: 19,
      ),
    );
  }
}
