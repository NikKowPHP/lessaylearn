import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/providers/favorite_provider.dart';
import 'package:lessay_learn/core/providers/known_word_provider.dart';
import 'package:lessay_learn/core/providers/language_service_provider.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lessay_learn/core/services/translate_service.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';


class TappableText extends ConsumerStatefulWidget {
  final String text;
  final bool isUserMessage;
  final List<FavoriteModel> favorites;
  final List<KnownWordModel> knownWords;

  const TappableText({
    Key? key,
    required this.text,
    required this.isUserMessage,
    required this.favorites,
    required this.knownWords,
  }) : super(key: key);

  @override
  ConsumerState<TappableText> createState() => TappableTextState();
}

class TappableTextState extends ConsumerState<TappableText> {
  late List<JustTheController> tooltipControllers = [];

  late List<_WordSpan> _wordSpans;

  @override
  void initState() {
    super.initState();
    _wordSpans = _splitTextIntoWordSpans(widget.text);
    tooltipControllers = List.generate(
      _wordSpans.where((span) => span.isWord).length,
      (_) => JustTheController(),
    );
  }

  @override
  void dispose() {
    for (var controller in tooltipControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<_WordSpan> _splitTextIntoWordSpans(String text) {
    final RegExp wordRegex =
        RegExp(r"\p{L}[\p{L}\p{M}'\p{Nd}]*", unicode: true);
    final List<_WordSpan> spans = [];
    int lastIndex = 0;

    for (Match match in wordRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(_WordSpan(text.substring(lastIndex, match.start), false));
      }
      spans.add(_WordSpan(match.group(0)!, true));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(_WordSpan(text.substring(lastIndex), false));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _wordSpans.asMap().entries.map((entry) {
        final index = entry.key;
        final span = entry.value;
        return span.isWord
            ? _buildTappableWord(span.text, _getWordIndex(index))
            : Text(span.text);
      }).toList(),
    );
  }

  int _getWordIndex(int spanIndex) {
    return _wordSpans.sublist(0, spanIndex).where((span) => span.isWord).length;
  }

  Widget _buildTappableWord(String word, int index) {
    final isFavorite =
        widget.favorites.any((favorite) => favorite.sourceText == word);
    final isKnown =
        widget.knownWords.any((knownWord) => knownWord.word == word);

    final currentUser = ref.watch(currentUserProvider).value;

    return GestureDetector(
      onTap: () {
        
        if (currentUser?.preferableTranslationLanguage == null) {
          _showLanguageSelectionSheet(context, word);
        } else {
          tooltipControllers[index].showTooltip();
          // Trigger translation when tapped
          ref.read(translationTriggerProvider.notifier).state =
              TranslationTrigger(
            messageId: '${widget.text}_$index',
            text: word,
            targetLanguage:
                currentUser!.preferableTranslationLanguage!,
          );
        }
        if (!isKnown) {
          _makeWordKnown(word);
        }
      },
      child: JustTheTooltip(
        controller: tooltipControllers[index],
        preferredDirection: AxisDirection.up,
        tailLength: 10.0,
        tailBaseWidth: 20.0,
        backgroundColor: CupertinoColors.systemBackground,
        content: _buildTooltipContent(word, '${widget.text}_$index'),
        triggerMode: TooltipTriggerMode.manual,
        isModal: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: _getHighlightColor(isKnown, isFavorite),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              word,
              style: TextStyle(
                color: widget.isUserMessage
                    ? CupertinoColors.white
                    : CupertinoColors.black,
                fontWeight: isKnown ? FontWeight.bold : FontWeight.normal,
                decoration:
                    isFavorite ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getHighlightColor(bool isKnown, bool isFavorite) {
    if (!isKnown) {
      return CupertinoColors.systemYellow.withOpacity(0.3);
    } else if (isFavorite) {
      return widget.isUserMessage
          ? CupertinoColors.systemPink
              .withOpacity(0.3) // Different color for current user's favorites
          : CupertinoColors.systemBlue
              .withOpacity(0.3); // Slight blue for other user's favorites
    } else {
      return CupertinoColors.transparent;
    }
  }

  Widget _buildTooltipContent(String word, String messageId) {
    return Consumer(
      builder: (context, ref, child) {
        final favorites = ref.watch(favoritesProvider);
        bool isFavorite =
            favorites.any((favorite) => favorite.sourceText == word);
        final translationAsyncValue =
            ref.watch(translatedMessageProvider(messageId));

        return Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              translationAsyncValue.when(
                data: (translation) => translation != null
                    ? Text('Translation: ${translation.translatedText}')
                    : Text('Tap to translate'),
                loading: () => CupertinoActivityIndicator(),
                error: (error, _) => Text('Error: $error'),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => _toggleFavorite(
                    word, isFavorite, translationAsyncValue.value),
                child: Icon(
                  isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
                  color: CupertinoColors.activeBlue,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleFavorite(String word, bool isFavorite,
      TranslationResult? translationResult) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    if (isFavorite) {
      final favoriteToRemove = ref
          .read(favoritesProvider)
          .firstWhere((fav) => fav.sourceText == word);
      await ref
          .read(favoritesProvider.notifier)
          .removeFavorite(favoriteToRemove.id);
    } else {
      final newFavorite = FavoriteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id,
        sourceText: word,
        translatedText: translationResult!
            .translatedText, 
        sourceLanguage: currentUser.preferableTranslationLanguage!, 
        targetLanguage: translationResult
            .detectedLanguage, 
      );
      await ref.read(favoritesProvider.notifier).addFavorite(newFavorite);
    }
  }

  Future<void> _makeWordKnown(String word) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    if (!widget.knownWords.any((knownWord) => knownWord.word == word)) {
      final newKnownWord = KnownWordModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id,
        word: word,
        language: currentUser.preferableTranslationLanguage!,
      );
      await ref.read(knownWordsProvider.notifier).addKnownWord(newKnownWord);
    }
  }

 Future<void> _setPreferredLanguage(String languageCode) async {
    final currentUserAsync = ref.read(currentUserProvider);
    
    currentUserAsync.whenData((currentUser) async {
      final updatedUser = currentUser.copyWith(preferableTranslationLanguage: languageCode);
      await ref.read(currentUserProvider.notifier).updateUser(updatedUser);
    });
  }

  Future<void> _translateWord(String word, String targetLanguage) async {
    // Implement the translation logic here
    // You can use the translatedMessageProvider or create a new provider for word translation
  }

  Future<void> _showLanguageSelectionSheet(
      BuildContext context, String word) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    final languageModels =
        await ref.read(languagesProvider(currentUser.id).future);

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Select Preferred Translation Language'),
        actions: languageModels
            .map((lang) => CupertinoActionSheetAction(
                  child: Text(lang.name),
                  onPressed: () {
                    Navigator.pop(context);
                    _setPreferredLanguage(lang.shortcut);
                    _translateWord(word, lang.shortcut);
                  },
                ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _WordSpan {
  final String text;
  final bool isWord;

  _WordSpan(this.text, this.isWord);
}
