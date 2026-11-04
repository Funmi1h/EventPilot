import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eventpilot/core/theme/app_colors.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/screens/home/dashboard_controller.dart';
import 'package:eventpilot/presentation/widgets/app_icon_box.dart';
import 'package:eventpilot/presentation/widgets/app_tag.dart';
import 'package:eventpilot/presentation/widgets/app_button.dart';
import 'package:eventpilot/presentation/widgets/section_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = Get.put(DashboardController());
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    //on force le rechargement des donnees du dashboard
    _controller.initDashboard();
  }

  void _onBottomNavTapped(int index) {
    setState(() => _currentNavIndex = index);
    final eventId = _controller.currentEvent.value?.id ?? '';
    final budget = _controller.currentEvent.value?.budget ?? 0.0;

    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed(AppRoutes.tasks, arguments: eventId)?.then((_) {
          _controller.initDashboard();
        });
        break;
      case 2:
        Get.toNamed(
          AppRoutes.expenses,
          arguments: {'eventId': eventId, 'budget': budget},
        )?.then((_) {
          _controller.initDashboard();
        });
        break;
      case 3:
        Get.toNamed(AppRoutes.participants, arguments: eventId);
        break;
    }
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _getTodayString() {
    final now = DateTime.now();
    const days = [
      '', 'LUNDI', 'MARDI', 'MERCREDI', 'JEUDI', 'VENDREDI', 'SAMEDI', 'DIMANCHE'
    ];
    const months = [
      '', 'JANVIER', 'FÉVRIER', 'MARS', 'AVRIL', 'MAI', 'JUIN',
      'JUILLET', 'AOÛT', 'SEPTEMBRE', 'OCTOBRE', 'NOVEMBRE', 'DÉCEMBRE'
    ];
    return '${days[now.weekday]} ${now.day} ${months[now.month]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.ink),
            );
          }

          final event = _controller.currentEvent.value;

          return RefreshIndicator(
            color: AppColors.ink,
            onRefresh: () => _controller.initDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 26),
                  if (event == null)
                    _buildNoEventState()
                  else ...[
                    _buildEventSummary(),
                    const SizedBox(height: 22),
                    _buildBudgetCard(),
                    const SizedBox(height: 26),
                    _buildAlertsSection(),
                    const SizedBox(height: 26),
                    SectionHeader(
                      title: 'Suivi des tâches',
                      actionLabel: 'Tout voir',
                      onAction: () {
                        Get.toNamed(
                          AppRoutes.tasks,
                          arguments: event.id ?? '',
                        )?.then((_) => _controller.initDashboard());
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTaskStats(),
                    const SizedBox(height: 26),
                    SectionHeader(
                      title: 'Dernières dépenses',
                      actionLabel: 'Historique',
                      onAction: () {
                        Get.toNamed(
                          AppRoutes.expenses,
                          arguments: {
                            'eventId': event.id ?? '',
                            'budget': event.budget,
                          },
                        )?.then((_) => _controller.initDashboard());
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildExpensesSection(),
                  ],
                ],
              ),
            ),
          );
        }),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTodayString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Bonjour ${_controller.userName}',
                style: const TextStyle(
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
          onTap: () => Get.toNamed(AppRoutes.events)?.then((_) {
            _controller.initDashboard();
          }),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profile),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                _controller.userInitials,
                style: const TextStyle(
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

  Widget _buildNoEventState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.celebration_outlined,
              size: 28,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bienvenue sur EventPilot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vous n\'avez pas encore d\'événement actif. Créez votre premier événement pour planifier vos tâches, budget et participants.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Créer un événement',
            onPressed: () => Get.toNamed(AppRoutes.createEvent)?.then((_) {
              _controller.initDashboard();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEventSummary() {
    final event = _controller.currentEvent.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel('Événement en cours'),
            InkWell(
              onTap: () => Get.toNamed(AppRoutes.events)?.then((_) {
                _controller.initDashboard();
              }),
              child: const Text(
                'Changer',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                event.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20),
              color: AppColors.accent,
              tooltip: 'Copier le lien public',
              onPressed: () {
                final link = event.computedPublicUrl;
                Clipboard.setData(ClipboardData(text: link));
                Get.snackbar(
                  'Lien copié',
                  'Le lien pour partager l\'événement a été copié dans votre presse-papiers.',
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 5),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${_formatDate(event.date)} · ${event.time}${event.location.isNotEmpty ? ' · ${event.location}' : ''}',
          style: const TextStyle(
            fontSize: 12,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            AppTag(_controller.countdownText, dotColor: AppColors.accent),
            const SizedBox(width: 6),
            AppTag(
              event.type,
              dotColor: AppColors.textTertiary,
            ),
            const SizedBox(width: 6),
            AppTag(
              event.isPaid
                  ? '${_formatAmount(event.ticketPrice)} FCFA'
                  : 'Entrée libre',
              dotColor: event.isPaid ? AppColors.info : AppColors.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetCard() {
    final remaining = _controller.remainingBudget;
    final total = _controller.initialBudget;
    final ratio = _controller.budgetUsedRatio;

    return GestureDetector(
      onTap: () {
        final event = _controller.currentEvent.value;
        if (event != null) {
          Get.toNamed(
            AppRoutes.expenses,
            arguments: {'eventId': event.id ?? '', 'budget': event.budget},
          )?.then((_) => _controller.initDashboard());
        }
      },
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
                  color: Colors.white.withOpacity(0.6),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatAmount(remaining)} FCFA',
              style: const TextStyle(
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
                value: ratio,
                minHeight: 5,
                backgroundColor: Colors.white.withOpacity(0.18),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _controller.isBudgetExceeded
                      ? AppColors.error
                      : (_controller.isBudgetLow
                          ? AppColors.warning
                          : AppColors.accent),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Initial : ${_formatAmount(total)} FCFA',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Text(
                  'Dépensé : ${_formatAmount(_controller.totalExpenses)} FCFA',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    final alerts = <Widget>[];

    if (_controller.isBudgetExceeded) {
      alerts.add(
        _buildAlert(
          dotColor: AppColors.error,
          title: 'Budget initial dépassé',
          subtitle:
              'Le total des dépenses excède le budget alloué à cet événement.',
        ),
      );
    } else if (_controller.isBudgetLow) {
      alerts.add(
        _buildAlert(
          dotColor: AppColors.warning,
          title: 'Budget faible',
          subtitle:
              'Il reste moins de 20 % du budget initialement prévu.',
        ),
      );
    }

    if (_controller.overdueTasksCount > 0) {
      if (alerts.isNotEmpty) alerts.add(const SizedBox(height: 8));
      alerts.add(
        _buildAlert(
          dotColor: AppColors.error,
          title: '${_controller.overdueTasksCount} tâche(s) en retard',
          subtitle: 'Des échéances sont dépassées. Consultez la liste des tâches.',
        ),
      );
    }

    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('À surveiller'),
        const SizedBox(height: 10),
        ...alerts,
      ],
    );
  }

  Widget _buildAlert({
    required Color dotColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
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
    final tasks = _controller.tasks;
    final total = tasks.length;
    final done = _controller.completedTasksCount;
    final remaining = _controller.remainingTasksCount;
    final overdue = _controller.overdueTasksCount;
    final ratio = _controller.taskProgressRatio;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total == 0
                    ? 'Aucune tâche créée'
                    : '$done sur $total tâche${total > 1 ? 's' : ''} terminée${done > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(ratio * 100).round()} %',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTaskStatItem('$done', 'Faites', AppColors.success),
              _buildTaskStatItem('$remaining', 'Restantes', AppColors.textPrimary),
              _buildTaskStatItem('$overdue', 'En retard', AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStatItem(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesSection() {
    final expenses = _controller.expenses;
    if (expenses.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'Aucune dépense enregistrée pour le moment.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      );
    }

    final topExpenses = expenses.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: topExpenses.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          return Column(
            children: [
              ListTile(
                dense: true,
                leading: const AppIconBox(icon: Icons.payments_outlined),
                title: Text(
                  exp.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  '${exp.expenseDate.day}/${exp.expenseDate.month}/${exp.expenseDate.year}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
                trailing: Text(
                  '${_formatAmount(exp.amount)} F',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (index < topExpenses.length - 1)
                const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}
