class AppRoutes {
  AppRoutes._();

  // ── Accueil & Auth ──
  static const String HOME = '/home';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String FORGOT_PASSWORD = '/forgot-password';

  // ── Profil ──
  static const String PROFILE = '/profile';

  // ── Dashboard organisateur ──
  static const String DASHBOARD_ORGANIZER = '/dashboard/organizer';

  // ── Événements ──
  static const String EVENTS = '/events';
  static const String EVENT_DETAILS = '/events/details';
  static const String CREATE_EVENT = '/events/create';
  static const String EDIT_EVENT = '/events/edit';

  // ── Tâches ──
  static const String TASKS = '/tasks';
  static const String CREATE_TASK = '/tasks/create';

  // ── Dépenses ──
  static const String EXPENSES = '/expenses';
  static const String CREATE_EXPENSE = '/expenses/create';

  // ── Participants ──
  static const String PARTICIPANTS = '/participants';

  // ── Paiements ──
  static const String PAYMENTS = '/payments';

  // ── Page publique invité ──
  static const String PUBLIC_EVENT = '/public/event';
  static const String PAYMENT_SIMULATION = '/public/payment';
  static const String REGISTRATION_SUCCESS = '/public/success';

  // ── Compatibilité avec anciens paramètres ──
  static const String EVENT = '/event/:eventId';
  static const String TASK = '/task/:taskId';
  static const String EVENT_TASK = '/events/:eventId/tasks/:taskId';
}
