class UserInfoResponse {
  final bool success;
  final int? id;
  final String? name;
  final String? email;
  final String? roles;
  final String? error;

  UserInfoResponse({
    required this.success,
    this.id,
    this.name,
    this.email,
    this.roles,
    this.error,
  });
} 