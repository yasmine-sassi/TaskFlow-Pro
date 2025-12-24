class ApiEndpoints {
  // Use 10.0.2.2 for Android emulators; swap to your host IP or 127.0.0.1 for iOS/simulator.
  static const String baseUrl = "http://10.0.2.2:3000";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String logout = "/auth/logout";
  static const String me = "/auth/me";
  static const String projects = "/projects";
  static const String tasks = "/tasks";
  static const String comments = "/comments";
  static const String activities = "/activities";
}
