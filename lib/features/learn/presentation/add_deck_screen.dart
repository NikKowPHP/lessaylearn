import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:uuid/uuid.dart';


class AddDeckScreen extends ConsumerStatefulWidget {
  const AddDeckScreen({Key? key}) : super(key: key);

  @override
  _AddDeckScreenState createState() => _AddDeckScreenState();
}

class _AddDeckScreenState extends ConsumerState<AddDeckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _languageLevelController = TextEditingController();
  final _sourceLanguageController = TextEditingController();
  final _targetLanguageController = TextEditingController();
 String? _nameError;
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _languageLevelController.dispose();
    _sourceLanguageController.dispose();
    _targetLanguageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add New Deck'),
        trailing: CupertinoButton(
          child: Text('Save'),
          onPressed: _saveDeck,
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
               CupertinoTextField(
                controller: _nameController,
                placeholder: 'Deck Name',
                onChanged: (value) {
                  // Validate the name as the user types
                  setState(() {
                    _nameError = value.isEmpty ? 'Please enter a deck name' : null;
                  });
                },
              ),
              if (_nameError != null)
              SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _descriptionController,
                placeholder: 'Description (optional)',
                maxLines: null, // Allow multiple lines
              ),
              SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _languageLevelController,
                placeholder: 'Language Level (e.g., Beginner, Intermediate)',
              ),
              SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _sourceLanguageController,
                placeholder: 'Source Language (e.g., English)',
              ),
              SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _targetLanguageController,
                placeholder: 'Target Language (e.g., Spanish)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDeck() {
    if (_formKey.currentState!.validate()) {
      final newDeck = DeckModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        cardCount: 0, // Initially 0 cards
        lastStudied: DateTime.now(),
        languageLevel: _languageLevelController.text,
        sourceLanguage: _sourceLanguageController.text,
        targetLanguage: _targetLanguageController.text,
      );

      ref.read(flashcardRepositoryProvider).addDeck(newDeck);

      // Refresh the decks provider to show the new deck in the list
      ref.refresh(decksProvider);

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
  }
}