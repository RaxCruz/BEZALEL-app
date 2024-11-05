class RegisterResponse {
  final bool success;
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? role;
  final String? error;

  RegisterResponse({
    required this.success,
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.role,
    this.error,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: true,
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      role: json['role'],
    );
  }
}
