// lib/features/learn/presentation/learn_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/presentation/deck_detail_screen.dart';
import 'package:lessay_learn/features/learn/presentation/widgets/deck_list_item.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsyncValue = ref.watch(decksProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Learn'),
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
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await ref.refresh(decksProvider.future);
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final deck = decks[index];
              return DeckListItem(
                deck: deck,
                onTap: () => _navigateToDeckDetail(context, deck),
              );
            },
            childCount: decks.length,
          ),
        ),
      ],
    );
  }

  void _navigateToDeckDetail(BuildContext context, DeckModel deck) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DeckDetailScreen(deck: deck),
      ),
    );
  }
}