import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : Titre et cloche de notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tableau de bord',
                        style: TextStyle(fontFamily: 'Inter', color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Mariage Rita & Marc',
                        style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.black87, size: 22),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Badges (J-53, Date, Page publiée)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5B846),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('J-53', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Sam. 14 déc. 2026', style: TextStyle(fontFamily: 'Inter', color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Page publiée', style: TextStyle(fontFamily: 'Inter', color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Carte Synthèse du budget (Jaune)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5B846),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Synthèse du budget · restant', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('700 000 FCFA', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.72,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Budget initial', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 10)),
                            Text('2 500 000', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total dépensé', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 10)),
                            Text('1 800 000', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Utilisé', style: TextStyle(fontFamily: 'Inter', color: Colors.white70, fontSize: 10)),
                            Text('72 %', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Carte Montant total collecté (Vert clair)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.credit_card, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Montant total collecté', style: TextStyle(fontFamily: 'Inter', color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('960 000 FCFA', style: TextStyle(fontFamily: 'Inter', color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('64 paiements réussis · 6 en attente', style: TextStyle(fontFamily: 'Inter', color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section Alertes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Alertes', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('3', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildAlertCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                bgColor: const Color(0xFFFFECEE),
                title: 'Tâche en retard',
                subtitle: 'Confirmer le traiteur – échéance dépassée',
              ),
              const SizedBox(height: 8),
              _buildAlertCard(
                icon: Icons.access_time,
                iconColor: Colors.orange,
                bgColor: const Color(0xFFFFF7E6),
                title: 'Échéance proche',
                subtitle: 'Décoration florale – le 05 nov.',
              ),
              const SizedBox(height: 8),
              _buildAlertCard(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Colors.amber,
                bgColor: const Color(0xFFFFFBE6),
                title: 'Budget restant faible',
                subtitle: 'Il reste 28 % du budget (700 000 FCFA)',
              ),
              const SizedBox(height: 20),

              // Suivi des tâches
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Suivi des tâches', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Voir tout', style: TextStyle(fontFamily: 'Inter', color: Color(0xFFE5B846))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTaskStatCard('3', 'Prioritaires', Colors.indigo)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTaskStatCard('1', 'En retard', Colors.red)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTaskStatCard('8', 'Terminées', Colors.green)),
                ],
              ),
              const SizedBox(height: 20),

              // Derniers paiements
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Derniers paiements', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Voir tous', style: TextStyle(fontFamily: 'Inter', color: Color(0xFFE5B846))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildPaymentTile('AD', 'Aurore DOSSOU', 'Aujourd\'hui · 10h24', '15 000 F'),
                    const Divider(height: 1),
                    _buildPaymentTile('FH', 'Fabrice HOUNKPÈ', 'Hier · 18h02', '15 000 F'),
                    const Divider(height: 1),
                    _buildPaymentTile('NK', 'Nadège KPOSSOU', '20 oct. · 09h15', '15 000 F'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dépenses récentes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dépenses récentes', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Historique', style: TextStyle(fontFamily: 'Inter', color: Color(0xFFE5B846))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildExpenseTile(Icons.music_note, 'Sonorisation DJ Max', 'Animation · 21 oct.', '-150 000'),
                    const Divider(height: 1),
                    _buildExpenseTile(Icons.description_outlined, 'Faire-part imprimés', 'Impression · 22 oct.', '-100 000'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // Barre de navigation inférieure
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: const Color(0xFFE5B846),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Aperçu'),
            BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tâches'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Dépenses'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Participants'),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard({required IconData icon, required Color iconColor, required Color bgColor, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontFamily: 'Inter', color: iconColor, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontFamily: 'Inter', color: Colors.black87, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStatCard(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: TextStyle(fontFamily: 'Inter', color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontFamily: 'Inter', color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(String initials, String name, String date, String amount) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEEF2FF),
            child: Text(initials, style: const TextStyle(fontFamily: 'Inter', color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontFamily: 'Inter', color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Payé', style: TextStyle(fontFamily: 'Inter', color: Color(0xFF16A34A), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTile(IconData icon, String title, String categoryDate, String amount) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.indigo, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(categoryDate, style: const TextStyle(fontFamily: 'Inter', color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red)),
        ],
      ),
    );
  }
}