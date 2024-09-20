import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/learn/presentation/screens/favorite_list_screen.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';

class AddDeckScreen extends ConsumerStatefulWidget {
  @override
  _AddDeckScreenState createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends ConsumerState<AddDeckScreen> {
  LanguageModel? sourceLanguage;
  LanguageModel? targetLanguage;

  @override
  Widget build(BuildContext context) {
    final deckService = ref.watch(deckServiceProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add New Deck'),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              child: Text('Select Source Language'),
              onPressed: () => _showLanguageSelector(context, deckService, true),
            ),
            CupertinoButton(
              child: Text('Select Target Language'),
              onPressed: () => _showLanguageSelector(context, deckService, false),
            ),
            CupertinoButton.filled(
              child: Text('Select Favorites'),
              onPressed: sourceLanguage != null && targetLanguage != null
                  ? () => _navigateToFavoriteList(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, DeckService deckService, bool isSource) async {
    final languages = await deckService.getLanguages();
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(isSource ? 'Select Source Language' : 'Select Target Language'),
          actions: languages.map((language) {
            return CupertinoActionSheetAction(
              child: Text(language.name),
              onPressed: () {
                setState(() {
                  if (isSource) {
                    sourceLanguage = language;
                  } else {
                    targetLanguage = language;
                  }
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _navigateToFavoriteList(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FavoriteListScreen(
          sourceLanguageId: sourceLanguage!.id,
          targetLanguageId: targetLanguage!.id,
        ),
      ),
    );
  }
}