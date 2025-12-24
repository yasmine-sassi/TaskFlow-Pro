/// Single source of truth for the access token used by AuthInterceptor.
class TokenStore {
  String? _token;

  Future<String?> getToken() async => _token;

  void setToken(String? token) => _token = token;
}
