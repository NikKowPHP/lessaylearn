// lib/features/learn/presentation/learn_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/presentation/screens/add_deck_screen.dart';
import 'package:lessay_learn/features/learn/presentation/widgets/deck_list_item.dart';
import 'package:lessay_learn/features/learn/providers/deck_provider.dart';
import 'package:go_router/go_router.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(decksProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Learn'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.add), 
          onPressed: () async {
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AddDeckScreen(),
              ),
            );
            // Refresh decks after returning from AddDeckScreen
            ref.read(decksProvider.notifier).loadDecks();
          },
        ),
      ), 
      child: SafeArea(
        child: decks.isEmpty
            ? Center(child: Text('No decks available. Create one!'))
            : ListView.builder(
                itemCount: decks.length,
                itemBuilder: (context, index) {
                  final deck = decks[index];
                  return DeckListItem(
                    deck: deck,
                    onTap: () {
                      context.push('/deck/${deck.id}');
                    },
                  );
                },
              ),
      ),
    );
  }
}