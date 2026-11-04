import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/supabase_client.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/screens/events/controller/event_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _fullName = '';
  String _email = '';
  String _phone = '';
  final String _role = 'Organisateur';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  //charger les vraies informations de l'utilisateur connecte
  void _loadUserProfile() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final meta = user.userMetadata ?? {};
      setState(() {
        _email = user.email ?? '';
        _fullName = meta['full_name']?.toString() ??
            (_email.contains('@') ? _email.split('@').first : 'Organisateur');
        _phone = meta['phone']?.toString() ?? user.phone ?? 'Non renseigné';
      });
    } else {
      setState(() {
        _fullName = 'Organisateur';
        _email = 'Non connecté';
        _phone = 'Non renseigné';
      });
    }
  }

  //calculer les initiales du nom
  String get _initials {
    if (_fullName.trim().isEmpty) return 'EP';
    final parts = _fullName.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'EP';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  //ouvrir le formulaire de modification du profil
  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _fullName);
    final phoneCtrl = TextEditingController(text: _phone == 'Non renseigné' ? '' : _phone);

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
              onPressed: () async {
                final newName = nameCtrl.text.trim();
                final newPhone = phoneCtrl.text.trim();

                try {
                  //mettre a jour les meta-donnees dans supabase
                  await supabase.auth.updateUser(
                    UserAttributes(
                      data: {
                        'full_name': newName,
                        'phone': newPhone,
                      },
                    ),
                  );

                  setState(() {
                    _fullName = newName;
                    _phone = newPhone.isNotEmpty ? newPhone : 'Non renseigné';
                  });

                  Navigator.pop(ctx);
                  Get.snackbar(
                    'Profil mis à jour',
                    'Vos informations ont été enregistrées.',
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                  );
                } catch (e) {
                  Get.snackbar(
                    'Erreur',
                    'Impossible de mettre à jour le profil : $e',
                    snackPosition: SnackPosition.TOP,
                    duration: const Duration(seconds: 5),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  //confirmer la deconnexion et fermer la session supabase
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
      onConfirm: () async {
        Get.back();
        //fermer reellement la session supabase
        await supabase.auth.signOut();
        Get.offAllNamed(AppRoutes.login);
        Get.snackbar(
          'Déconnecté',
          'Votre session a été fermée.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //compter les evenements reels depuis le controller des evenements
    final eventController = Get.isRegistered<EventController>()
        ? Get.find<EventController>()
        : Get.put(EventController());

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
              Obx(() => _buildStats(eventController.events.length)),
              const SizedBox(height: 16),
              _buildMenu(),
              const SizedBox(height: 16),
              _buildLogout(),
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

  Widget _buildStats(int eventsCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildStat('$eventsCount', 'Événements'),
          _buildStatDivider(),
          _buildStat('Organisateur', 'Rôle'),
          _buildStatDivider(),
          _buildStat('Actif', 'Statut'),
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
              fontSize: 18,
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
            icon: Icons.celebration_outlined,
            title: 'Mes événements',
            subtitle: 'Voir la liste de mes événements',
            onTap: () => Get.toNamed(AppRoutes.events),
          ),
          const Divider(height: 1, indent: 60),
          _buildListTile(
            icon: Icons.shield_outlined,
            title: 'Sécurité du compte',
            subtitle: 'Authentification gérée par Supabase',
            onTap: () {
              Get.snackbar(
                'Sécurité',
                'Votre session est chiffrée avec Supabase Auth.',
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 5),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: AppIconBox(icon: icon),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.textTertiary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 19,
        color: AppColors.textTertiary,
      ),
    );
  }

  Widget _buildLogout() {
    return InkWell(
      onTap: _confirmLogout,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
            SizedBox(width: 8),
            Text(
              'Déconnexion',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
