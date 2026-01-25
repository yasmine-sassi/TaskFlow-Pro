class ApiEndpoints {
  // Use 10.0.2.2 for Android emulator to access host machine's localhost
  // Use localhost for iOS simulator or web
  static const String baseUrl = "http://10.0.2.2:3000";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String projects = "/projects";
  static const String tasks = "/tasks";
  static const String comments = "/comments";
  static const String activities = "/activities";
}
