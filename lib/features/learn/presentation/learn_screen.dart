// lib/features/learn/presentation/learn_screen.dart
import 'package:flutter/cupertino.dart';
//import material.dart
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/presentation/deck_detail_screen.dart';
import 'package:lessay_learn/features/learn/presentation/study_session_screen.dart';
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
    Widget _buildLearnView(BuildContext context, WidgetRef ref, Map<String, List<FlashcardModel>> flashcardStatus) {
    return ListView(
      children: [
        _buildStatusSection(context, 'New', flashcardStatus['new']!, CupertinoColors.activeBlue),
        _buildStatusSection(context, 'Learn', flashcardStatus['learn']!, CupertinoColors.destructiveRed),
        _buildStatusSection(context, 'Review', flashcardStatus['review']!, CupertinoColors.activeGreen),
      ],
    );
  }
  Widget _buildDueCardsSection(BuildContext context, WidgetRef ref) {
  final dueFlashcardsAsyncValue = ref.watch(dueFlashcardsProvider);
  return dueFlashcardsAsyncValue.when(
    data: (dueFlashcards) => _buildStatusSection(context, 'Due', dueFlashcards, CupertinoColors.activeOrange),
    loading: () => CupertinoActivityIndicator(),
    error: (_, __) => Text('Error loading due flashcards'),
  );
}


 Widget _buildDeckList(BuildContext context, WidgetRef ref, List<DeckModel> decks) {
    return ListView.builder(
      itemCount: decks.length,
      itemBuilder: (context, index) {
        final deck = decks[index];
        return DeckListItem(
          deck: deck,
          onTap: () => _navigateToDeckDetail(context, deck),
        );
      },
    );
  }
void _startStudySession(BuildContext context, List<FlashcardModel> flashcards) {
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => StudySessionScreen(flashcards: flashcards),
    ),
  );
}

  Widget _buildStatusSection(BuildContext context, String title, List<FlashcardModel> flashcards, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '$title (${flashcards.length})',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        if (flashcards.isNotEmpty)
          CupertinoButton(
            child: Text('Study $title'),
            onPressed: () => _startStudySession(context, flashcards),
          ),
        const Divider(),
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