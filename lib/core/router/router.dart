import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/widgets/cupertino_bottom_nav_bar.dart';
import 'package:lessay_learn/features/chat/widgets/chat_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:lessay_learn/features/chat/widgets/settings_screen.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';



// Placeholder screens for Calls and Camera
class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Calls')),
      child: Center(child: Text('Calls Screen')),
    );
  }
}

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Camera')),
      child: Center(child: Text('Camera Screen')),
    );
  }
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/', // Start at the home screen
    routes: [
      // ShellRoute for bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return CupertinoBottomNavBar(
            // Pass the child to be displayed based on the selected tab
            key: state.pageKey,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => CupertinoPage(
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/calls',
            pageBuilder: (context, state) => CupertinoPage(
              child: const CallsScreen(),
            ),
          ),
          GoRoute(
            path: '/camera',
            pageBuilder: (context, state) => CupertinoPage(
              child: const CameraScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CupertinoPage(
              child: const SettingsScreen(),
            ),
          ),
          GoRoute(
            path: '/chat/:chatId',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final chat = state.extra as ChatModel;
              return CupertinoPage(
                child: IndividualChatScreen(chat: chat),
              );
            },
          ),
        ],
      ),
    ],
  );
}