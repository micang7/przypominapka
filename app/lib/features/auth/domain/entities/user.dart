class User {
  final String id;
  final String login;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.login,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          login == other.login &&
          email == other.email &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      login.hashCode ^
      email.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'User(id: $id, login: $login, email: $email, createdAt: $createdAt, updatedAt: $updatedAt)';
}
