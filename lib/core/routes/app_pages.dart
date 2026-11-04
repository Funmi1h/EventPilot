import 'package:get/get.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/screens/authentification/views/login_view.dart';
import 'package:eventpilot/presentation/screens/authentification/views/register_view.dart';
import 'package:eventpilot/presentation/screens/authentification/views/verify_email_view.dart';
import 'package:eventpilot/presentation/screens/authentification/views/forgot_password_view.dart';
import 'package:eventpilot/presentation/screens/home/home_view.dart';
import 'package:eventpilot/presentation/screens/home/dashboard_organizer.dart';
import 'package:eventpilot/presentation/screens/profile/profile_view.dart';
import 'package:eventpilot/presentation/screens/events/events_list_view.dart';
import 'package:eventpilot/presentation/screens/events/event_details_view.dart';
import 'package:eventpilot/presentation/screens/events/create_event_view.dart';
import 'package:eventpilot/presentation/screens/events/edit_event_view.dart';
import 'package:eventpilot/presentation/screens/tasks/task_list_view.dart';
import 'package:eventpilot/presentation/screens/tasks/create_task_view.dart';
import 'package:eventpilot/presentation/screens/tasks/controller/task_controller.dart';
import 'package:eventpilot/presentation/screens/tasks/controller/create_task_controller.dart';
import 'package:eventpilot/presentation/screens/expenses/expense_list_view.dart';
import 'package:eventpilot/presentation/screens/expenses/create_expense_view.dart';
import 'package:eventpilot/presentation/screens/participants/participants_list_view.dart';
import 'package:eventpilot/presentation/screens/payments/payments_list_view.dart';
import 'package:eventpilot/presentation/screens/public/public_event_view.dart';
import 'package:eventpilot/presentation/screens/public/payment_simulation_view.dart';
import 'package:eventpilot/presentation/screens/public/registration_success_view.dart';
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: AppRoutes.verifyEmail,
      page: () => const VerifyEmailView(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
    ),

    // ── Dashboard ──
    GetPage(
      name: AppRoutes.dashboardOrganizer,
      page: () => const DashboardScreen(),
    ),

    // ── Profil ──
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
    ),

    // ── Événements ──
    GetPage(
      name: AppRoutes.events,
      page: () => const EventsListView(),
    ),
    GetPage(
      name: AppRoutes.event,
      page: () => const EventDetailsView(),
    ),
    GetPage(
      name: AppRoutes.createEvent,
      page: () => const CreateEventView(),
    ),
    GetPage(
      name: AppRoutes.editEvent,
      page: () => const EditEventView(),
    ),

    // ── Tâches ──
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TaskListController>(() => TaskListController());
      }),
    ),
    GetPage(
      name: AppRoutes.createTask,
      page: () => const CreateTaskView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CreateTaskController>(() => CreateTaskController());
      }),
    ),

    // ── Dépenses ──
    GetPage(
      name: AppRoutes.expenses,
      page: () => const ExpenseListView(),
    ),
    GetPage(
      name: AppRoutes.createExpense,
      page: () => const CreateExpenseView(),
    ),

    // ── Participants ──
    GetPage(
      name: AppRoutes.participants,
      page: () => const ParticipantsListView(),
    ),

    // ── Paiements ──
    GetPage(
      name: AppRoutes.payments,
      page: () => const PaymentsListView(),
    ),

    // ── Public / Invité ──
    GetPage(
      name: AppRoutes.publicEvent,
      page: () => PublicEventView(
        eventData: (Get.arguments is Map<String, dynamic>)
            ? (Get.arguments as Map<String, dynamic>)
            : null,
      ),
    ),
    GetPage(
      name: AppRoutes.paymentSimulation,
      page: () => PaymentSimulationView(
        participantName: Get.arguments?['participantName'] ?? 'Marc william',
        participantEmail: Get.arguments?['participantEmail'] ?? 'marcwilliam@gmail.com',
        participantPhone: Get.arguments?['participantPhone'] ?? '+229 01 97 45 23 18',
        amount: Get.arguments?['amount'] ?? '15 000',
        eventTitle: Get.arguments?['eventTitle'] ?? 'Mariage Rita & Marc',
      ),
    ),
    GetPage(
      name: AppRoutes.registrationSuccess,
      page: () => RegistrationSuccessView(
        participantName: Get.arguments?['participantName'] ?? 'Marc william',
        participantEmail: Get.arguments?['participantEmail'] ?? 'marcwilliam@gmail.com',
        eventTitle: Get.arguments?['eventTitle'] ?? 'Mariage Rita & Marc',
        ticketCode: Get.arguments?['ticketCode'] ?? 'EP-MARIAGE-8823',
        isPaid: Get.arguments?['isPaid'] ?? true,
        amountPaid: Get.arguments?['amountPaid'] ?? '15 000 FCFA',
      ),
    ),
  ];
}