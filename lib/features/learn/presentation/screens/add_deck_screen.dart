import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/presentation/screens/favorite_list_screen.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';
import 'package:uuid/uuid.dart';

class AddDeckScreen extends ConsumerStatefulWidget {
  @override
  _AddDeckScreenState createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends ConsumerState<AddDeckScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _languageLevel = 'Beginner';
  LanguageModel? sourceLanguage;
  LanguageModel? targetLanguage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deckService = ref.watch(deckServiceProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add New Deck'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Save'),
          onPressed: _saveDeck,
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Deck Name',
                padding: EdgeInsets.all(12),
              ),
              SizedBox(height: 16),
              CupertinoTextField(
                controller: _descriptionController,
                placeholder: 'Description',
                padding: EdgeInsets.all(12),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              CupertinoButton(
                child: Text(sourceLanguage?.name ?? 'Select Source Language'),
                onPressed: () => _showLanguageSelector(context, deckService, true),
              ),
              SizedBox(height: 8),
              CupertinoButton(
                child: Text(targetLanguage?.name ?? 'Select Target Language'),
                onPressed: () => _showLanguageSelector(context, deckService, false),
              ),
              SizedBox(height: 16),
              CupertinoSlidingSegmentedControl<String>(
                children: {
                  'Beginner': Text('Beginner'),
                  'Intermediate': Text('Intermediate'),
                  'Advanced': Text('Advanced'),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _languageLevel = value);
                  }
                },
                groupValue: _languageLevel,
              ),
              SizedBox(height: 24),
              CupertinoButton.filled(
                child: Text('Select Favorites'),
                onPressed: sourceLanguage != null && targetLanguage != null
                    ? () => _navigateToFavoriteList(context)
                    : null,
              ),
            ],
          ),
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

  void _saveDeck() {
    if (_formKey.currentState!.validate()) {
      final newDeck = DeckModel(
        id: Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        cardCount: 0,
        lastStudied: DateTime.now(),
        languageLevel: _languageLevel,
        sourceLanguage: sourceLanguage!.id,
        targetLanguage: targetLanguage!.id,
      );
      
      ref.read(deckServiceProvider).addDeck(newDeck).then((_) {
        Navigator.pop(context);
      });
    }
  }
}