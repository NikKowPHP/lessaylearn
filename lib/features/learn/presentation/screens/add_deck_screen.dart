import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/presentation/screens/favorite_list_screen.dart';
import 'package:lessay_learn/features/learn/providers/deck_provider.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart' as deckService;
// import 'package:lessay_learn/features/learn/services/deck_service.dart';
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
      previousPageTitle: 'Back',
    ),
    child: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildTextInput(_nameController, 'Deck Name'),
            SizedBox(height: 16),
            _buildTextInput(_descriptionController, 'Description', maxLines: 3),
            SizedBox(height: 24),
            _buildLanguageSection(deckService),
            SizedBox(height: 24),
            _buildLanguageLevelSelector(),
            SizedBox(height: 24),
            _buildImportButton(),
            SizedBox(height: 16),
            if (selectedSourceLanguage != null && selectedTargetLanguage != null)
              _buildSelectFavoritesButton(),
            if (selectedFavorites.isNotEmpty)
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

   Future<void> _importFlashcards(BuildContext context) async {
    final importService = ref.read(importFlashcardsServiceProvider);
    if (selectedSourceLanguage != null && selectedTargetLanguage != null) {
      try {
         final importedFavorites = await importService.importFlashcardsWithoutDeckId(selectedSourceLanguage!, selectedTargetLanguage!);
         debugPrint('importedFavorites: $importedFavorites');
        // Add imported favorites to the deck after it's created

        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Flashcards Imported'),
            content: const Text('Flashcards have been successfully imported.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
               onPressed: () {
                  // invalidate favorites
                  ref.invalidate(flashcardServiceProvider);
                  
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } catch (e) {
        // Handle errors appropriately, e.g., show an error message
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error Importing Flashcards'),
            content: Text('An error occurred: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
   }

  

  void _showLanguagePicker(
      BuildContext context, List<String> languages, bool isSource) {
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
                  selectedTargetLanguage =
                      null; // Reset target language when source changes
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


Widget _buildTextInput(TextEditingController controller, String placeholder, {int maxLines = 1}) {
  return CupertinoTextField(
    controller: controller,
    placeholder: placeholder,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    maxLines: maxLines,
    decoration: BoxDecoration(
      border: Border.all(color: CupertinoColors.systemGrey4),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

  Widget _buildLanguageSection(deckService.DeckService deckService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Languages'),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildLanguageSelector(deckService, true)),
            SizedBox(width: 16),
            Expanded(child: _buildLanguageSelector(deckService, false)),
          ],
        ),
      ],
    );
  }
 Widget _buildLanguageSelector(deckService.DeckService deckService, bool isSource) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isSource ? 'From' : 'To'),
        SizedBox(height: 8),
        FutureBuilder<List<String>>(
          future: isSource 
              ? deckService.getAvailableSourceLanguages()
              : deckService.getAvailableTargetLanguages(selectedSourceLanguage ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CupertinoActivityIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No languages available');
            }
            return CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: CupertinoColors.systemGrey,
              child: Text(
                isSource 
                    ? (selectedSourceLanguage ?? 'Select language')
                    : (selectedTargetLanguage ?? 'Select language'),
              ),
              onPressed: () => _showLanguagePicker(context, snapshot.data!, isSource),
            );
          },
        ),
      ],
    );
  }

 Widget _buildLanguageLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Language Level'),
        SizedBox(height: 12),
        CupertinoSlidingSegmentedControl<String>(
          children: {
            'Beginner': Text('Beginner'),
            'Intermediate': Text('Intermediate'),
            'Advanced': Text('Advanced'),
          },
          onValueChanged: (value) {
            if (value != null) setState(() => _languageLevel = value);
          },
          groupValue: _languageLevel,
        ),
      ],
    );
  }

 Widget _buildImportButton() {
    return CupertinoButton.filled(
      child: const Text('Import Flashcards'),
      onPressed: selectedSourceLanguage != null && selectedTargetLanguage != null
          ? () => _importFlashcards(context)
          : null,
    );
  }

  Widget _buildSelectFavoritesButton() {
    return CupertinoButton(
      color: CupertinoColors.activeGreen,
      child: Text('Select Favorites'),
      onPressed: () => _navigateToFavoriteListScreen(context),
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
        if (!await deckService.isFlashcardInDeck(favoriteId, newDeck.id)) {
          await deckService.addFavoriteAsDeckFlashcard(newDeck.id, favoriteId);
        }
      }

      // Update favorites to mark them as flashcards
      await deckService.updateFavoritesAsFlashcards(selectedFavorites);

      Navigator.pop(context);
    }
  }
}
