import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/blocs/bet/bet_bloc.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Always sign out for development so app starts unauthenticated
  await FirebaseAuth.instance.signOut();

  // Initialize dependency injection
  await di.init();

  runApp(const SalesBetsApp());
}

class SalesBetsApp extends StatelessWidget {
  const SalesBetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Betting Bloc
        BlocProvider(create: (_) => di.sl<BetBloc>()),

        // Auth Bloc with initial check
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sales Bets',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system, // Follows system setting
        routes: appRoutes,
        initialRoute: '/splash', // SplashPage will handle auth redirect
      ),
    );
  }
}
