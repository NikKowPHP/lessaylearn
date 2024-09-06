import 'package:go_router/go_router.dart';
import 'package:lessay_learn/features/chat/widgets/chat_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:lessay_learn/features/chat/widgets/settings_screen.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';

GoRouter createAppRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
       
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
       GoRoute(
        path: '/chat/:chatId',
        builder: (BuildContext context, GoRouterState state) {
          final chat = state.extra as ChatModel; 
          return IndividualChatScreen(chat: chat);
        },
      ),
    ],
  );
}