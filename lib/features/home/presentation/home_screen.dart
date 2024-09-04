import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lessay_learn/features/chat/widgets/chat_list.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

@override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Chats'),
      ),
      // child: SafeArea(
        child: ChatList(),
      // ),
    );
  }
}