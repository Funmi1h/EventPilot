import 'package:get/get.dart';
import 'package:eventpilot/core/routes/app_routes.dart';
import 'package:eventpilot/presentation/screens/authentification/login_view.dart';
import 'package:eventpilot/presentation/screens/authentification/register_view.dart';
import 'package:eventpilot/presentation/screens/events/create_event_view.dart';
import 'package:eventpilot/presentation/screens/home/dashboard_organizer.dart';
import 'package:eventpilot/presentation/screens/home/home_view.dart';
import 'package:eventpilot/presentation/screens/tasks/controllers/create_task_controller.dart';
import 'package:eventpilot/presentation/screens/tasks/controllers/task_list_controller.dart';
import 'package:eventpilot/presentation/screens/tasks/create_task_view.dart';
import 'package:eventpilot/presentation/screens/tasks/task_list_view.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.HOME, page: () => const HomeView()),
    GetPage(name: AppRoutes.LOGIN, page: () => const LoginView()),
    GetPage(name: AppRoutes.REGISTER, page: () => const RegisterView()),
    GetPage(
      name: AppRoutes.DASHBOARD_ORGANIZER,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.TASKS,
      page: () => const TaskListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TaskListController>(() => TaskListController());
      }),
    ),
    GetPage(name: AppRoutes.EVENT, page: () => const DashboardScreen()),
    GetPage(name: AppRoutes.EVENTS, page: () => const CreateEventView()),
    GetPage(
      name: AppRoutes.TASK,
      page: () => const CreateTaskView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CreateTaskController>(() => CreateTaskController());
      }),
    ),
    GetPage(
      name: AppRoutes.EVENT_TASK,
      page: () => const CreateTaskView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CreateTaskController>(() => CreateTaskController());
      }),
    ),
  ];
}