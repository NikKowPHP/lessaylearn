import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/features/chat/widgets/settings_screen.dart';

import 'package:lessay_learn/features/home/presentation/home_screen.dart';


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
       GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
   
    ],
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'Lessay Learn',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      routerConfig: _router,
    );
  }
}