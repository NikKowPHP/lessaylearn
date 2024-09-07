// lib/features/learn/presentation/learn_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
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
          data: (decks) => _buildDeckList(context, decks),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildDeckList(BuildContext context, List<DeckModel> decks) {
    if (decks.isEmpty) {
      return const Center(child: Text('No decks available'));
    }

    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            // Implement refresh logic here
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => DeckListItem(deck: decks[index]),
            childCount: decks.length,
          ),
        ),
      ],
    );
  }
}