class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';

  static const String dashboardOrganizer = '/dashboard/organizer';

  static const String events = '/events';
  static const String event = '/events/details';
  static const String createEvent = '/events/create';
  static const String editEvent = '/events/edit';

  static const String tasks = '/tasks';
  static  String task(String id ) => '/tasks/$id';
  static const String createTask = '/tasks/create';
  static String editTask(String id) => "/tasks/edit/$id";

  static const String expenses = '/expenses';
  static const String createExpense = '/expenses/create';
  static String editExpense(String id) => 'expenses/edit/$id';

  static const String participants = '/participants';
  static const String payments = '/payments';

  static const String publicEvent = '/public/event';
  static const String paymentSimulation = '/public/payment';
  static const String registrationSuccess = '/public/success';

  static const String eventTask = '/events/:eventId/tasks/:taskId';
}