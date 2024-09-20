import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
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
  List<String> selectedFavorites = [];

  bool get _isFormValid =>
      _nameController.text.isNotEmpty &&
      selectedSourceLanguage != null &&
      selectedTargetLanguage != null &&
      selectedFavorites.isNotEmpty;

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
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              CupertinoTextFormFieldRow(
                controller: _nameController,
                placeholder: 'Deck Name',
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
                onChanged: (_) => setState(() {}),
              ),
              CupertinoTextFormFieldRow(
                controller: _descriptionController,
                placeholder: 'Description',
              ),
              SizedBox(height: 16),
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
                      return Text('No languages available');
                    }
                    return CupertinoButton(
                      child: Text(selectedTargetLanguage ?? 'Select language'),
                      onPressed: () => _showLanguagePicker(context, snapshot.data!, false),
                    );
                  },
                ),
              SizedBox(height: 16),
              Text('Language Level'),
              CupertinoSegmentedControl<String>(
                children: {
                  'Beginner': Text('Beginner'),
                  'Intermediate': Text('Intermediate'),
                  'Advanced': Text('Advanced'),
                },
                onValueChanged: (value) {
                  setState(() => _languageLevel = value);
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
              Text('Selected Favorites: ${selectedFavorites.length}'),
              SizedBox(height: 24),
              CupertinoButton.filled(
                child: Text('Create Deck'),
                onPressed: _isFormValid ? _saveDeck : null,
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

  void _navigateToFavoriteListScreen(BuildContext context) async {
    final result = await Navigator.push<List<String>>(
      context,
      CupertinoPageRoute(
        builder: (context) => FavoriteListScreen(
          sourceLanguageId: selectedSourceLanguage!,
          targetLanguageId: selectedTargetLanguage!,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        selectedFavorites = result;
      });
    }
  }

  void _saveDeck() async {
    if (_formKey.currentState!.validate() &&
        selectedSourceLanguage != null &&
        selectedTargetLanguage != null) {
      final deckService = ref.read(deckServiceProvider);
      final newDeck = DeckModel(
        id: Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        cardCount: selectedFavorites.length,
        lastStudied: DateTime.now(),
        languageLevel: _languageLevel,
        sourceLanguage: selectedSourceLanguage!,
        targetLanguage: selectedTargetLanguage!,
      );
      
      await deckService.addDeck(newDeck);

      // Create flashcards from favorites
      for (String favoriteId in selectedFavorites) {
        await deckService.addFavoriteAsDeckFlashcard(newDeck.id, favoriteId);
      }

      // Update favorites to mark them as flashcards
      await deckService.updateFavoritesAsFlashcards(selectedFavorites);

      Navigator.pop(context);
    }
  }
}