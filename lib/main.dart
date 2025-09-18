import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
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


  // Initialize dependency injection
  await di.init();

  runApp(SalesBetsApp());
}

class SalesBetsApp extends StatelessWidget {
  SalesBetsApp({super.key});

  // Global theme mode notifier
  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<BetBloc>()),
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatus())),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, mode, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sales Bets',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          routes: appRoutes,
          initialRoute: '/splash',
        ),
      ),
    );
  }
}
