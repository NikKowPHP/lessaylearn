import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'My Flutter App',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      routerConfig: _router,
    );
  }

   GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      // Add other routes here
    ],
  );
}