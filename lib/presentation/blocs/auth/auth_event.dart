import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Email login
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Email signup
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Google login
class GoogleSignInRequested extends AuthEvent {}

// Apple login
class AppleSignInRequested extends AuthEvent {}

// Logout
class SignOutRequested extends AuthEvent {}

//login status check
class CheckAuthStatus extends AuthEvent {}
