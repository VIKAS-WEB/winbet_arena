import 'package:flutter/material.dart';
import 'package:winbet_arena/presentation/pages/auth_pages/loginPage.dart';
import 'package:winbet_arena/presentation/pages/auth_pages/signup_page.dart';
import 'package:winbet_arena/presentation/pages/auth_pages/splash_page.dart';
import 'package:winbet_arena/presentation/pages/homePage.dart';
import 'pages/betting_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/splash': (_) => const SplashPage(),
  '/': (_) => const HomePage(),
  '/login': (_) => const LoginPage(),
  '/signup': (_) => const SignupPage(),
  '/bet': (_) => const BettingPage(),
};
