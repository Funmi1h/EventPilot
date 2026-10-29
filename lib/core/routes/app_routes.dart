class AppRoutes{
  static const HOME = "/home";
  static const  LOGIN = "/login";
  static const  REGISTER = "/register";
  static const  DASHBOARD_ORGANIZER = "/dashboard/organizer";
  static const TASKS = "/tasks";
  static const  EVENTS = "/events";
  static const  EVENT = "/event/:eventId";
  static const  TASK = "/task/:taskId";

  //route pour une tache spécifique appartenant a un evenement
  // Route for a task belonging to a specific event.
  static const String EVENT_TASK = "/events/:eventId/tasks/:taskId";

}