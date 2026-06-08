import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String login,
    required String password,
    required String deviceId,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String login,
    required String password,
    required String confirmPassword,
    required String deviceId,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
}

@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String login,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required UserDto user,
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenExpiresAt,
    required DateTime refreshTokenExpiresAt,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}

@freezed
abstract class AuthRefreshResponse with _$AuthRefreshResponse {
  const factory AuthRefreshResponse({
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenExpiresAt,
    required DateTime refreshTokenExpiresAt,
  }) = _AuthRefreshResponse;

  factory AuthRefreshResponse.fromJson(Map<String, dynamic> json) => _$AuthRefreshResponseFromJson(json);
}

@freezed
abstract class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String oldPassword,
    required String newPassword,
    required String newConfirmPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);
}
