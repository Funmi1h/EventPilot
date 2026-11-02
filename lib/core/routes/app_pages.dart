import 'package:get/get.dart';
import 'package:eventpilot/core/routes/app_routes.dart';

// ── Auth ──
import 'package:eventpilot/presentation/screens/authentification/views/login_view.dart';
import 'package:eventpilot/presentation/screens/authentification/views/register_view.dart';
import 'package:eventpilot/presentation/screens/authentification/views/forgot_password_view.dart';

// ── Home & Dashboard ──
import 'package:eventpilot/presentation/screens/home/home_view.dart';
import 'package:eventpilot/presentation/screens/home/dashboard_organizer.dart';

// ── Profil ──
import 'package:eventpilot/presentation/screens/profile/profile_view.dart';

// ── Événements ──
import 'package:eventpilot/presentation/screens/events/events_list_view.dart';
import 'package:eventpilot/presentation/screens/events/event_details_view.dart';
import 'package:eventpilot/presentation/screens/events/create_event_view.dart';
import 'package:eventpilot/presentation/screens/events/edit_event_view.dart';

// ── Tâches ──
import 'package:eventpilot/presentation/screens/tasks/task_list_view.dart';
import 'package:eventpilot/presentation/screens/tasks/create_task_view.dart';
import 'package:eventpilot/presentation/screens/tasks/controllers/task_list_controller.dart';
import 'package:eventpilot/presentation/screens/tasks/controllers/create_task_controller.dart';

// ── Dépenses ──
import 'package:eventpilot/presentation/screens/expenses/expense_list_view.dart';
import 'package:eventpilot/presentation/screens/expenses/create_expense_view.dart';

// ── Participants ──
import 'package:eventpilot/presentation/screens/participants/participants_list_view.dart';

// ── Paiements ──
import 'package:eventpilot/presentation/screens/payments/payments_list_view.dart';

// ── Public / Invité ──
import 'package:eventpilot/presentation/screens/public/public_event_view.dart';
import 'package:eventpilot/presentation/screens/public/payment_simulation_view.dart';
import 'package:eventpilot/presentation/screens/public/registration_success_view.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // ── Accueil ──
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
    ),

    // ── Auth ──
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
    ),

    // ── Dashboard ──
    GetPage(
      name: AppRoutes.DASHBOARD_ORGANIZER,
      page: () => const DashboardScreen(),
    ),

    // ── Profil ──
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
    ),

    // ── Événements ──
    GetPage(
      name: AppRoutes.EVENTS,
      page: () => const EventsListView(),
    ),
    GetPage(
      name: AppRoutes.EVENT_DETAILS,
      page: () => const EventDetailsView(),
    ),
    GetPage(
      name: AppRoutes.CREATE_EVENT,
      page: () => const CreateEventView(),
    ),
    GetPage(
      name: AppRoutes.EDIT_EVENT,
      page: () => const EditEventView(),
    ),

    // ── Tâches ──
    GetPage(
      name: AppRoutes.TASKS,
      page: () => const TaskListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TaskListController>(() => TaskListController());
      }),
    ),
    GetPage(
      name: AppRoutes.CREATE_TASK,
      page: () => const CreateTaskView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CreateTaskController>(() => CreateTaskController());
      }),
    ),

    // ── Dépenses ──
    GetPage(
      name: AppRoutes.EXPENSES,
      page: () => const ExpenseListView(),
    ),
    GetPage(
      name: AppRoutes.CREATE_EXPENSE,
      page: () => const CreateExpenseView(),
    ),

    // ── Participants ──
    GetPage(
      name: AppRoutes.PARTICIPANTS,
      page: () => const ParticipantsListView(),
    ),

    // ── Paiements ──
    GetPage(
      name: AppRoutes.PAYMENTS,
      page: () => const PaymentsListView(),
    ),

    // ── Public / Invité ──
    GetPage(
      name: AppRoutes.PUBLIC_EVENT,
      page: () => const PublicEventView(),
    ),
    GetPage(
      name: AppRoutes.PAYMENT_SIMULATION,
      page: () => const PaymentSimulationView(),
    ),
    GetPage(
      name: AppRoutes.REGISTRATION_SUCCESS,
      page: () => const RegistrationSuccessView(),
    ),
  ];
}
