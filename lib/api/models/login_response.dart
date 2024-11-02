class LoginResponse {
  final bool success;
  final String? token;
  final String? userEmail;
  final String? userNicename;
  final String? userDisplayName;
  final String? error;

  LoginResponse({
    required this.success,
    this.token,
    this.userEmail,
    this.userNicename,
    this.userDisplayName,
    this.error,
  });
} 