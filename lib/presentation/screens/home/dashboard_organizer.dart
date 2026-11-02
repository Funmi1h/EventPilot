import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/section_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed(AppRoutes.TASKS);
        break;
      case 2:
        Get.toNamed(AppRoutes.EXPENSES);
        break;
      case 3:
        Get.toNamed(AppRoutes.PARTICIPANTS);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 26),
              _buildEventSummary(),
              const SizedBox(height: 22),
              _buildBudgetCard(),
              const SizedBox(height: 10),
              _buildCollectedCard(),
              const SizedBox(height: 26),
              const SectionLabel('À surveiller'),
              const SizedBox(height: 10),
              _buildAlert(
                dotColor: AppColors.warning,
                title: 'Budget à 72 % consommé',
                subtitle:
                    'Le solde restant passe sous la barre de sécurité.',
              ),
              const SizedBox(height: 8),
              _buildAlert(
                dotColor: AppColors.error,
                title: '2 tâches en retard',
                subtitle: 'Contacter le traiteur · Valider la playlist DJ',
              ),
              const SizedBox(height: 26),
              SectionHeader(
                title: 'Suivi des tâches',
                actionLabel: 'Tout voir',
                onAction: () => Get.toNamed(AppRoutes.TASKS),
              ),
              const SizedBox(height: 10),
              _buildTaskStats(),
              const SizedBox(height: 26),
              SectionHeader(
                title: 'Derniers paiements',
                actionLabel: 'Tout voir',
                onAction: () => Get.toNamed(AppRoutes.PAYMENTS),
              ),
              const SizedBox(height: 10),
              _buildSurface(
                children: [
                  _buildPaymentTile(
                    'AD',
                    'Aurore DOSSOU',
                    'Aujourd\'hui · 14h20',
                    '15 000 F',
                  ),
                  const Divider(height: 1, indent: 58),
                  _buildPaymentTile(
                    'GA',
                    'Gildas AGOSSOU',
                    'Hier · 18h45',
                    '15 000 F',
                  ),
                  const Divider(height: 1, indent: 58),
                  _buildPaymentTile(
                    'NT',
                    'Noélie TOHOUE',
                    '01 nov. · 09h10',
                    '15 000 F',
                  ),
                ],
              ),
              const SizedBox(height: 26),
              SectionHeader(
                title: 'Dernières dépenses',
                actionLabel: 'Historique',
                onAction: () => Get.toNamed(AppRoutes.EXPENSES),
              ),
              const SizedBox(height: 10),
              _buildSurface(
                children: [
                  _buildExpenseTile(
                    Icons.music_note_outlined,
                    'Acompte Orchestre live',
                    'Animation · 28 oct.',
                    '350 000 F',
                  ),
                  const Divider(height: 1, indent: 58),
                  _buildExpenseTile(
                    Icons.local_printshop_outlined,
                    'Faire-part & menus',
                    'Impression · 24 oct.',
                    '85 000 F',
                  ),
                  const Divider(height: 1, indent: 58),
                  _buildExpenseTile(
                    Icons.restaurant_outlined,
                    'Acompte Vin d\'honneur',
                    'Traiteur · 20 oct.',
                    '600 000 F',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentNavIndex,
            onTap: _onBottomNavTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.space_dashboard_outlined, size: 21),
                activeIcon: Icon(Icons.space_dashboard_rounded, size: 21),
                label: 'Aperçu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist_outlined, size: 21),
                activeIcon: Icon(Icons.checklist_rounded, size: 21),
                label: 'Tâches',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined, size: 21),
                activeIcon:
                    Icon(Icons.account_balance_wallet_rounded, size: 21),
                label: 'Dépenses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_rounded, size: 21),
                activeIcon: Icon(Icons.people_rounded, size: 21),
                label: 'Participants',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SAMEDI 14 DÉCEMBRE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Bonjour Marc',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.7,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        _buildTopAction(
          icon: Icons.event_note_outlined,
          onTap: () => Get.toNamed(AppRoutes.EVENTS),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.PROFILE),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'MK',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildEventSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Cérémonie en cours'),
        const SizedBox(height: 8),
        const Text(
          'Mariage Rita & Marc',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '14 décembre 2026 · 15h00 · Hôtel du Lac, Cotonou',
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            AppTag('J-53', dotColor: AppColors.accent),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.PUBLIC_EVENT),
              child: const AppTag('Page publiée', dotColor: AppColors.success),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.EXPENSES),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Budget restant',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    color: Colors.white70,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '700 000 FCFA',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.8,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.72,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Initial · 2 500 000 FCFA',
                  style: TextStyle(fontSize: 11, color: Colors.white54),
                ),
                Text(
                  'Dépensé · 72 %',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectedCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.PAYMENTS),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Montant collecté',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '960 000 FCFA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '64 paiements · 6 en attente',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlert({
    required Color dotColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildStat('2', 'En retard', AppColors.error),
          _buildVerticalDivider(),
          _buildStat('4', 'En cours', AppColors.accent),
          _buildVerticalDivider(),
          _buildStat('6', 'Terminées', AppColors.success),
        ],
      ),
    );
  }

  Widget _buildStat(String count, String label, Color dotColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 34, color: AppColors.border);
  }

  Widget _buildSurface({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildPaymentTile(
    String initials,
    String name,
    String date,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _StatusDot(color: AppColors.success),
                  SizedBox(width: 4),
                  Text(
                    'Payé',
                    style: TextStyle(
                      fontSize: 9.5,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTile(
    IconData icon,
    String title,
    String meta,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          AppIconBox(icon: icon, size: 34, iconSize: 16, radius: 10),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '− $amount',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
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
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
