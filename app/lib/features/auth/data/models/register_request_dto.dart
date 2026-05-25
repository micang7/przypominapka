class RegisterRequestDto {
  final String login;
  final String password;
  final String confirmPassword;

  RegisterRequestDto({
    required this.login,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) {
    return RegisterRequestDto(
      login: json['login'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
