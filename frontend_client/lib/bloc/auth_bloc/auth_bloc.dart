import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/request/login_request.dart';
import '../../model/request/register_request.dart';
import '../../model/response/customer_response.dart';
import '../../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  final AuthRepository authRepository;

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());
      final data = await authRepository.login(request: event.data);
      emit(AuthLogin(data: data));
    } catch (e) {
      emit(AuthLoginFailed(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());
      await authRepository.register(request: event.data);
      emit(const AuthRegister());
    } catch (e) {
      emit(AuthRegisterFailed(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    // Simply go back to initial state
    emit(const AuthInitial());
  }
}
