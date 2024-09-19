// lib/features/learn/presentation/learn_screen.dart
import 'package:flutter/cupertino.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';

import 'package:lessay_learn/features/learn/presentation/add_deck_screen.dart';
import 'package:lessay_learn/features/learn/presentation/deck_detail_screen.dart';

import 'package:lessay_learn/features/learn/presentation/widgets/deck_list_item.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:go_router/go_router.dart';
class LearnScreen extends ConsumerWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsyncValue = ref.watch(decksProvider);

    return CupertinoPageScaffold(
     navigationBar: CupertinoNavigationBar(
        middle: Text('Learn'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.add), 
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AddDeckScreen(),
              ),
            );
          },
        ),
      ), 
      child: SafeArea(
        child: decksAsyncValue.when(
          data: (decks) => _buildDeckList(context, ref, decks),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }




 Widget _buildDeckList(BuildContext context, WidgetRef ref, List<DeckModel> decks) {
  return ListView.builder(
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
  );
  }

 


}