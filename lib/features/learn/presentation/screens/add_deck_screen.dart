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
    String? selectedSourceLanguage;
  String? selectedTargetLanguage;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Source Language'),
              FutureBuilder<List<String>>(
                future: deckService.getAvailableSourceLanguages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoActivityIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No languages available');
                  }
                  return CupertinoButton(
                    child: Text(selectedSourceLanguage ?? 'Select language'),
                    onPressed: () => _showLanguagePicker(context, snapshot.data!, true),
                  );
                },
              ),
              SizedBox(height: 16),
              Text('Target Language'),
              if (selectedSourceLanguage != null)
                FutureBuilder<List<String>>(
                  future: deckService.getAvailableTargetLanguages(selectedSourceLanguage!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CupertinoActivityIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No target languages available');
                    }
                    return CupertinoButton(
                      child: Text(selectedTargetLanguage ?? 'Select language'),
                      onPressed: () => _showLanguagePicker(context, snapshot.data!, false),
                    );
                  },
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
                onPressed: selectedSourceLanguage != null && selectedTargetLanguage != null
                    ? () => _navigateToFavoriteListScreen(context)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showLanguagePicker(BuildContext context, List<String> languages, bool isSource) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (int index) {
              setState(() {
                if (isSource) {
                  selectedSourceLanguage = languages[index];
                  selectedTargetLanguage = null; // Reset target language when source changes
                } else {
                  selectedTargetLanguage = languages[index];
                }
              });
            },
            children: languages.map((lang) => Text(lang)).toList(),
          ),
        );
      },
    );
  }


  void _navigateToFavoriteListScreen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => FavoriteListScreen(
          sourceLanguageId: selectedSourceLanguage!,
          targetLanguageId: selectedTargetLanguage!,
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