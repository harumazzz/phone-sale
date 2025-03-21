part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthRegister extends AuthState {
  const AuthRegister();

  @override
  List<Object?> get props => [];
}

final class AuthLogin extends AuthState {
  const AuthLogin();

  @override
  List<Object?> get props => [];
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthLoginFailed extends AuthState {
  const AuthLoginFailed({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

final class AuthRegisterFailed extends AuthState {
  const AuthRegisterFailed({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
