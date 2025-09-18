
import 'package:equatable/equatable.dart';
import 'package:winbet_arena/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial (before login)
class AuthInitial extends AuthState {}

// Loading
class AuthLoading extends AuthState {}

// Authenticated
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Not logged in
class AuthUnauthenticated extends AuthState {}

// Error
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
