import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/providers/sign_up_provider.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/providers/language_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class SignUpFormsScreen extends ConsumerStatefulWidget {
  final UserModel initialUser;

  const SignUpFormsScreen({Key? key, required this.initialUser})
      : super(key: key);

  @override
  _SignUpFormsScreenState createState() => _SignUpFormsScreenState();
}

class _SignUpFormsScreenState extends ConsumerState<SignUpFormsScreen> {
  late UserModel _user;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref.read(signUpProvider.notifier).completeSignUp(_user);
    }
  }

  void _showLanguageSelector(String title, List<UserLanguage> selectedLanguages, bool isTargetLanguage, Function(List<UserLanguage>) onSelect) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LanguageSelectorSheet(
          title: title,
          selectedLanguages: selectedLanguages,
          onSelect: (updatedLanguages) {
            setState(() {
              onSelect(updatedLanguages);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Complete Your Profile'),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CupertinoTextFormFieldRow(
                prefix: const Text('Name'),
                initialValue: _user.name,
                onChanged: (value) => _user = _user.copyWith(name: value),
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),
              CupertinoTextFormFieldRow(
                prefix: const Text('Age'),
                initialValue: _user.age.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    _user = _user.copyWith(age: int.tryParse(value) ?? 0),
                validator: (value) =>
                    int.tryParse(value!) == null ? 'Invalid age' : null,
              ),
              CupertinoTextFormFieldRow(
                prefix: const Text('Location'),
                initialValue: _user.location,
                onChanged: (value) => _user = _user.copyWith(location: value),
              ),
              CupertinoTextFormFieldRow(
                prefix: const Text('Bio'),
                initialValue: _user.bio,
                onChanged: (value) => _user = _user.copyWith(bio: value),
              ),
              _buildLanguageBottomBar(),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text('Complete Sign Up'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageBottomBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(top: BorderSide(color: CupertinoColors.systemGrey4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLanguageButton('Native', _user.sourceLanguageIds, false),
          _buildLanguageButton('Spoken', _user.spokenLanguageIds, false),
          _buildLanguageButton('Target', _user.targetLanguageIds, true),
        ],
      ),
    );
  }

   Widget _buildLanguageButton(String title, List<String> languageIds, bool isTargetLanguage) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          Text('${languageIds.length}', style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
      onPressed: () {
        // Fetch the UserLanguage objects based on the selected language IDs
        List<UserLanguage> selectedLanguages = languageIds.map((id) {
          return UserLanguage(
            id: '', // This will be generated when saving to the database
            userId: '', // This will be set when saving to the database
            languageId: id,
            name: '', // This will be set when we have the language data
            shortcut: '', // This will be set when we have the language data
            timestamp: DateTime.now(),
            level: 'Beginner', // Default level
            score: 0,
          );
        }).toList();

        _showLanguageSelector(
          'Select $title Languages',
          selectedLanguages,
          isTargetLanguage,
          (updatedLanguages) {
            if (title == 'Native') {
              _user = _user.copyWith(sourceLanguageIds: updatedLanguages.map((l) => l.languageId).toList());
            } else if (title == 'Spoken') {
              _user = _user.copyWith(spokenLanguageIds: updatedLanguages.map((l) => l.languageId).toList());
            } else if (title == 'Target') {
              _user = _user.copyWith(targetLanguageIds: updatedLanguages.map((l) => l.languageId).toList());
            }
          },
        );
      },
    );
  }
}

class LanguageSelectorSheet extends ConsumerStatefulWidget {
  final String title;
  final List<UserLanguage> selectedLanguages;
 final Function(List<UserLanguage>) onSelect;
 final bool isTargetLanguage;

  const LanguageSelectorSheet({
    Key? key,
    required this.title,
    required this.selectedLanguages,
    required this.onSelect,
        this.isTargetLanguage = false,
  }) : super(key: key);

  @override
  _LanguageSelectorSheetState createState() => _LanguageSelectorSheetState();
}

class _LanguageSelectorSheetState extends ConsumerState<LanguageSelectorSheet> {
  late List<UserLanguage> _selectedLanguages;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Initialize _selectedLanguages with the selectedLanguages passed from the parent
    _selectedLanguages = List.from(widget.selectedLanguages);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    final allLanguagesAsyncValue = ref.watch(allLanguagesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.title, style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          ),
          Expanded(
            child: allLanguagesAsyncValue.when(
              data: (languages) => CupertinoScrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected = _selectedLanguages.any((l) => l.languageId == language.id);

                    return Column(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${language.emoji} ${language.name}'),
                              Icon(
                                isSelected ? CupertinoIcons.minus_circle : CupertinoIcons.plus_circle,
                                color: isSelected ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                _selectedLanguages.removeWhere((l) => l.languageId == language.id);
                              } else {
                                _selectedLanguages.add(UserLanguage(
                                  id: '', // This will be generated when saving to the database
                                  userId: '', // This will be set when saving to the database
                                  languageId: language.id,
                                  name: language.name,
                                  shortcut: language.shortcut,
                                  timestamp: DateTime.now(),
                                  level: 'Beginner', // Default level
                                  score: 0,
                                ));
                              }
                            });
                            widget.onSelect(_selectedLanguages);
                          },
                        ),
                        if (isSelected && widget.isTargetLanguage)
                          CupertinoSegmentedControl<String>(
                            children: {
                              'Beginner': Text('Beginner'),
                              'Intermediate': Text('Intermediate'),
                              'Advanced': Text('Advanced'),
                            },
                            groupValue: _selectedLanguages.firstWhere((l) => l.languageId == language.id).level,
                            onValueChanged: (String value) {
                              setState(() {
                                final index = _selectedLanguages.indexWhere((l) => l.languageId == language.id);
                                _selectedLanguages[index] = _selectedLanguages[index].copyWith(level: value);
                              });
                              widget.onSelect(_selectedLanguages);
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
          CupertinoButton(
            child: const Text('Done'),
            onPressed: () {
              widget.onSelect(_selectedLanguages); // Ensure to call onSelect with the final selected languages
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
