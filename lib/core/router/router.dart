import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/core/widgets/cupertino_bottom_nav_bar.dart';
import 'package:lessay_learn/features/chat/widgets/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/widgets/create_chat_view.dart';

import 'package:lessay_learn/features/chat/widgets/settings_screen.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/world/presentation/world_screen.dart';
import 'package:lessay_learn/services/i_chat_service.dart';



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
            path: '/community',
            pageBuilder: (context, state) => const CupertinoPage(
              child: CommunityScreen(),
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
         // Give the chat route a name
      
        ],
      ),
      GoRoute(
        name: 'chatDetails',
        path: '/chat/:chatId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final chat = state.extra as ChatModel;
          return CupertinoPage(
            child: IndividualChatScreen(chat: chat),
          );
        },
      ),
        GoRoute(
        path: '/create-chat',
        pageBuilder: (context, state) => CupertinoPage(
          child: Consumer(
            builder: (context, ref, _) {
              final chatService = ref.watch(chatServiceProvider);
              return CreateChatView(chatService: chatService);
            },
          ),
        ),
      ),
    ],
  );
}