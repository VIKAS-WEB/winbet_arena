import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winbet_arena/data/repositories/auth_repository.dart';

import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/place_bet.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/bet/bet_bloc.dart';
import '../../domain/repositories/bet_repository.dart';
import '../../data/repositories/bet_repository_impl.dart';
import '../../data/datasources/remote/bet_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ----------------------
  // Remote Datasources
  // ----------------------
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      FirebaseAuth.instance,
      GoogleSignIn(),
    ),
  );

  sl.registerLazySingleton<BetRemoteDataSource>(
    () => BetRemoteDataSourceImpl(FirebaseFirestore.instance),
  );

  // ----------------------
  // Repositories
  // ----------------------
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<BetRepository>(
    () => BetRepositoryImpl(sl<BetRemoteDataSource>()), // pass remote datasource
  );

  // ----------------------
  // Usecases
  // ----------------------
  sl.registerLazySingleton(() => PlaceBet(sl<BetRepository>()));

  // ----------------------
  // Blocs
  // ----------------------
  sl.registerFactory(() => AuthBloc(sl<AuthRepository>()));
  sl.registerFactory(() => BetBloc(sl<PlaceBet>()));
}
