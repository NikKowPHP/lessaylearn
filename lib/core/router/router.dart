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
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/presentation/screens/deck_detail_screen.dart';
import 'package:lessay_learn/features/learn/presentation/screens/learn_screen.dart';
import 'package:lessay_learn/features/learn/presentation/screens/study_session_screen.dart';
import 'package:lessay_learn/features/profile/presentation/profile_screen.dart';
import 'package:lessay_learn/features/profile/presentation/user_gallery_screen.dart';
import 'package:lessay_learn/features/voicer/presentation/recording_screen.dart';
import 'package:lessay_learn/features/world/presentation/world_screen.dart';
import 'package:lessay_learn/features/statistics/presentation/statistics_screen.dart';




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
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return CupertinoBottomNavBar(
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
            path: '/learn',
            pageBuilder: (context, state) => CupertinoPage(
              child: const LearnScreen(),
            ),
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) => CupertinoPage(
              child: const StatisticsScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CupertinoPage(
              child: const SettingsScreen(),
            ),
          ),
          GoRoute(
            path: '/recording', // New route for RecordingScreen
            pageBuilder: (context, state) => CupertinoPage(
              child: const RecordingScreen(),
            ),
          ),
        ],
      ),
     GoRoute(
  name: 'chatDetails',
  path: '/chat/:chatId',
  pageBuilder: (context, state) {
    final chatId = state.pathParameters['chatId']!;
    return CupertinoPage(
         child: Consumer(
    builder: (context, ref, _) => FutureBuilder<ChatModel?>(
        future: ref.read(chatServiceProvider).getChatById(chatId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoPageScaffold(
              child: Center(child: CupertinoActivityIndicator()),
            );
          } else if (snapshot.hasError) {
            return CupertinoPageScaffold(
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (snapshot.data == null) {
            return const CupertinoPageScaffold(
              child: Center(child: Text('Chat not found')),
            );
          } else {
            return IndividualChatScreen(chat: snapshot.data!);
          }
        },
      ),
      ),
    );
  },
),
GoRoute(
  path: '/profile/:userId',
  pageBuilder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return CupertinoPage(
      child: ProfileScreen(userId: userId),
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


      GoRoute(
        path: '/deck/:deckId',
        pageBuilder: (context, state) {
       final deckId = state.pathParameters['deckId']!;
          return CupertinoPage(
            child: DeckDetailScreen(deckId: deckId),
          );
        },
      ),
      GoRoute(
        path: '/study-session/:deckId',
        pageBuilder: (context, state) {
          final deckId = state.pathParameters['deckId']!;
          return CupertinoPage(
            child: StudySessionScreen(deckId: deckId),
          );
        },
      ),

       // Add this new route for the user gallery
      GoRoute(
        path: '/user-gallery/:userId',
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return CupertinoPage(
            child: UserGalleryScreen(userId: userId),
          );
        },
      ),
    ],
  );
}

