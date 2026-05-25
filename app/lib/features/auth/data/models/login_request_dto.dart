class LoginRequestDto {
  final String login;
  final String password;

  LoginRequestDto({
    required this.login,
    required this.password,
  });

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) {
    return LoginRequestDto(
      login: json['login'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'password': password,
    };
  }
}
