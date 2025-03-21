part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class LoginEvent extends AuthEvent {
  const LoginEvent({required this.data});
  final LoginRequest data;

  @override
  List<Object?> get props => [data];
}

final class RegisterEvent extends AuthEvent {
  const RegisterEvent({required this.data});

  final RegisterRequest data;

  @override
  List<Object?> get props => [data];
}
