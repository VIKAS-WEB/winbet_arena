import 'package:firebase_auth/firebase_auth.dart';
import 'package:winbet_arena/data/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    try {
      final user = await remoteDataSource.signInWithEmail(email, password);
      return _mapFirebaseUserToEntity(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signUp(String email, String password) async {
    try {
      final user = await remoteDataSource.signUpWithEmail(email, password);
      return _mapFirebaseUserToEntity(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return _mapFirebaseUserToEntity(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signInWithApple() async {
    try {
      final user = await remoteDataSource.signInWithApple();
      return _mapFirebaseUserToEntity(user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  /// Returns currently logged-in user, if any
  @override
  UserEntity? currentUser() {
    final user = FirebaseAuth.instance.currentUser;
    return _mapFirebaseUserToEntity(user);
  }

  /// Helper to map Firebase User to domain UserEntity
  UserEntity? _mapFirebaseUserToEntity(User? user) {
    if (user == null) return null;
    return UserEntity(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
