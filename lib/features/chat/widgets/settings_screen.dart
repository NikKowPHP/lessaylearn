import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Settings'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => context.go('/'),
        ),
      ),
      child: const SafeArea(
        child: Center(
          child: Text('Settings Screen'),
        ),
      ),
    );
  }
}