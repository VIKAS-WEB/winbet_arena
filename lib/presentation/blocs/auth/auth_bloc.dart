import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:winbet_arena/data/repositories/auth_repository.dart';
import 'package:winbet_arena/presentation/blocs/auth/auth_event.dart';
import 'package:winbet_arena/presentation/blocs/auth/auth_state.dart';
import '../../../domain/entities/user_entity.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    // Email login
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signIn(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError("Login failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Email signup
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signUp(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError("Signup failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Google Sign-In
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signInWithGoogle();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError("Google login failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Apple Sign-In
    on<AppleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.signInWithApple();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError("Apple login failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<CheckAuthStatus>((event, emit) async {
      final user =
          repository.currentUser(); // method to get current Firebase user
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    // Logout
    on<SignOutRequested>((event, emit) async {
      await repository.signOut();
      emit(AuthUnauthenticated());
    });
  }
}
