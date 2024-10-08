import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/widgets/chat_list.dart';
import 'package:lessay_learn/features/chat/widgets/chat_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isAiTabActive = false;

  void _onTabChanged(bool isAiTab) {
    setState(() {
      _isAiTabActive = isAiTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600; // Adjust this breakpoint as needed

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Chats'),
        trailing: _isAiTabActive
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.go('/create-chat'),
                child: Icon(CupertinoIcons.create),
              )
            : null,
      ),
      child: SafeArea(
        child: isWideScreen
            ? Row(
                children: [
                  SizedBox(
                    width: 400,
                    child: ChatList(
                      isWideScreen: true,
                      selectedChatId: ref.watch(selectedChatIdProvider),
                      onTabChanged: _onTabChanged,
                    ),
                  ),
                  const CupertinoVerticalSeparator(),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final selectedChatId =
                            ref.watch(selectedChatIdProvider);
                        return selectedChatId != null
                            ? FutureBuilder<ChatModel?>(
                                future: ref
                                    .read(chatServiceProvider)
                                    .getChatById(selectedChatId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CupertinoActivityIndicator());
                                  } else if (snapshot.hasError ||
                                      snapshot.data == null) {
                                    return Center(
                                        child: Text('Error loading chat'));
                                  } else {
                                    return IndividualChatScreen(
                                        chat: snapshot.data!);
                                  }
                                },
                              )
                            : Center(
                                child:
                                    Text('Select a chat to start messaging'));
                      },
                    ),
                  ),
                ],
              )
            : ChatList(onTabChanged: _onTabChanged),
      ),
    );
  }
}

class CupertinoVerticalSeparator extends StatelessWidget {
  const CupertinoVerticalSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: CupertinoColors.separator,
    );
  }
}
