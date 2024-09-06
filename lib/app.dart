import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/router/router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'Lessay Learn',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemGrey,
      ),
      routerConfig: _router,
    );
  }
}