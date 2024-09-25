// lib/features/learn/presentation/deck_detail_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lessay_learn/core/SRSA/engine/srsa_algoritm.dart';
import 'package:lessay_learn/core/providers/favorite_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/presentation/screens/favorite_list_screen.dart';
import 'package:lessay_learn/features/learn/presentation/screens/study_session_screen.dart';
import 'package:lessay_learn/features/learn/presentation/widgets/flashcard_list_item.dart';
import 'package:lessay_learn/features/learn/providers/deck_provider.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:go_router/go_router.dart';

class DeckDetailScreen extends ConsumerWidget {
  final String deckId;

  const DeckDetailScreen({Key? key, required this.deckId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckAsyncValue = ref.watch(deckByIdProvider(deckId));
    final flashcardsAsyncValue = ref.watch(flashcardsForDeckProvider(deckId));

    return deckAsyncValue.when(
      data: (deck) =>
          _buildDeckDetail(context, ref, deck, flashcardsAsyncValue),
      loading: () => const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (error, _) => CupertinoPageScaffold(
        child: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildStudyButton(
      BuildContext context, WidgetRef ref, DeckModel deck) {
    final dueCountAsyncValue = ref.watch(dueFlashcardCountProvider(deck.id));

    return dueCountAsyncValue.when(
      data: (dueCount) {
        return CupertinoButton.filled(
          child: Text('Study Now ($dueCount cards)'),
          onPressed:
              dueCount > 0 ? () => _startStudySession(context, deck.id) : null,
        );
      },
      loading: () => CupertinoActivityIndicator(),
      error: (_, __) => Text('Error loading flashcards'),
    );
  }

  Widget _buildDeckDetail(BuildContext context, WidgetRef ref, DeckModel deck,
      AsyncValue<List<FlashcardModel>> flashcardsAsyncValue) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(deck.name),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () async {
                        final result = await Navigator.push<List<String>>(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => FavoriteListScreen(
                              sourceLanguageId: deck.sourceLanguage,
                              targetLanguageId: deck.targetLanguage,
                            ),
                          ),
                        );

                        if (result != null && result.isNotEmpty) {
                          // Convert favorites to flashcards and add them to the deck
                          await _addFavoritesToDeck(ref, deck.id, result);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text('Add Flashcards'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () async {             
                        final importService = ref.read(importFlashcardsServiceProvider);
                        await importService.importFlashcards(deck.id);
                        // Refresh the flashcards list
                        ref.invalidate(flashcardsForDeckProvider(deck.id));
                        Navigator.of(context).pop();
                      },
                      child: Text('Import Flashcards'),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                );
              },
            );
          },
          child: Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildDeckInfo(deck),
            _buildStudyButton(context, ref, deck),
            _buildFlashcardList(flashcardsAsyncValue, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckInfo(DeckModel deck) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(deck.description, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('Last studied: ${_formatDate(deck.lastStudied)}'),
          Text('Cards: ${deck.cardCount}'),
        ],
      ),
    );
  }

  Widget _buildAddFlashcardsButton(
      BuildContext context, DeckModel deck, WidgetRef ref) {
    return CupertinoButton(
      padding:
          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding
      onPressed: () async {
        final result = await Navigator.push<List<String>>(
          context,
          CupertinoPageRoute(
            builder: (context) => FavoriteListScreen(
              sourceLanguageId: deck.sourceLanguage,
              targetLanguageId: deck.targetLanguage,
            ),
          ),
        );

        if (result != null && result.isNotEmpty) {
          // Convert favorites to flashcards and add them to the deck
          await _addFavoritesToDeck(ref, deck.id, result);
        }
      },
      borderRadius: BorderRadius.circular(8.0), // Add border radius
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.add_circled, // Add an icon
            color: CupertinoColors.activeBlue, // Set icon color
          ),
          SizedBox(width: 8.0), // Space between icon and text
          Text(
            'Add Flashcards',
            style: TextStyle(
              color: CupertinoColors.activeBlue, // Set text color
              fontSize: 14.0, // Set text fontSize
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addFavoritesToDeck(
      WidgetRef ref, String deckId, List<String> favoriteIds) async {
    final deckService = ref.read(deckServiceProvider);
    // Get the full favorite objects

    // Create flashcards from favorites
    for (String favoriteId in favoriteIds) {
      if (!await deckService.isFlashcardInDeck(favoriteId, deckId)) {
        await deckService.addFavoriteAsDeckFlashcard(deckId, favoriteId);
      }
    }
    // Update favorites to mark them as flashcards
    await deckService.updateFavoritesAsFlashcards(favoriteIds);
    // Reload decks to update the state
    ref.invalidate(flashcardsForDeckProvider(deckId));
  }

  void _startStudySession(BuildContext context, String deckId) {
    context.push('/study-session/$deckId');
  }

  Widget _buildFlashcardList(
      AsyncValue<List<FlashcardModel>> flashcardsAsyncValue, WidgetRef ref) {
    return Expanded(
      child: flashcardsAsyncValue.when(
        data: (flashcards) {
          if (flashcards == null) {
            return Center(child: Text('No flashcards available'));
          }
          final flashcardStatus =
              ref.read(deckServiceProvider).getFlashcardStatus(flashcards);
          return Column(
            children: [
              _buildFlashcardListSection(
                  'New Cards', flashcardStatus['new'] ?? [], ref),
              _buildFlashcardListSection(
                  'To Learn', flashcardStatus['learn'] ?? [], ref),
              _buildFlashcardListSection(
                  'To Review', flashcardStatus['review'] ?? [], ref),
            ],
          );
        },
        loading: () => Center(child: CupertinoActivityIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildFlashcardListSection(
      String title, List<FlashcardModel> flashcards, WidgetRef ref) {
    if (flashcards.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: flashcards.length,
          itemBuilder: (context, index) =>
              FlashcardListItem(flashcard: flashcards[index]),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}
