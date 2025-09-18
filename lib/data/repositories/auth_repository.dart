
import 'package:winbet_arena/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Sign in with email & password
  Future<UserEntity?> signIn(String email, String password);

  /// Sign up with email & password
  Future<UserEntity?> signUp(String email, String password);

  /// Sign in with Google
  Future<UserEntity?> signInWithGoogle();

  /// Sign in with Apple
  Future<UserEntity?> signInWithApple();

  UserEntity? currentUser();


  /// Sign out user
  Future<void> signOut();
}
