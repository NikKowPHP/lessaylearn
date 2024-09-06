import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/features/chat/widgets/chat_list.dart';
import 'package:lessay_learn/services/i_chat_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final chatService = ref.watch(chatServiceProvider); 
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Chats'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.settings),
          onPressed: () => context.go('/settings'),
        ),
      ),
      child: SafeArea(
        child: ChatList(chatService: chatService),
      ),
    );
  }
}
