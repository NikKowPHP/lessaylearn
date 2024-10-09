import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/providers/sign_up_provider.dart';
import 'package:lessay_learn/core/models/language_model.dart';

import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/providers/language_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class SignUpFormsScreen extends ConsumerStatefulWidget {
  const SignUpFormsScreen({Key? key}) : super(key: key);

  @override
  _SignUpFormsScreenState createState() => _SignUpFormsScreenState();
}

class _SignUpFormsScreenState extends ConsumerState<SignUpFormsScreen> {
  late UserModel _user;
  final _formKey = GlobalKey<FormState>();
  List<UserLanguage> _selectedNativeLanguages = [];
  List<UserLanguage> _selectedSpokenLanguages = [];
  List<UserLanguage> _selectedTargetLanguages = [];

  final TextEditingController _interestsController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeUser(); // Safe to call here
    _initializeLanguages(); // Safe to call here
  }

  void _initializeUser() {
    final currentUserAsyncValue = ref.watch(currentUserProvider);
    currentUserAsyncValue.whenData((user) {
      setState(() {
        _user = user; // Assign the current user
      });
    });
  }

  void _initializeLanguages() {
    final allLanguagesAsyncValue = ref.read(allLanguagesProvider);
    allLanguagesAsyncValue.whenData((languages) {
      setState(() {
        _selectedNativeLanguages =
            _createUserLanguages(_user.sourceLanguageIds, languages);
        _selectedSpokenLanguages =
            _createUserLanguages(_user.spokenLanguageIds, languages);
        _selectedTargetLanguages =
            _createUserLanguages(_user.targetLanguageIds, languages);
      });
    });
  }

  List<UserLanguage> _createUserLanguages(
      List<String> languageIds, List<LanguageModel> allLanguages) {
    return languageIds.map((id) {
      final language = allLanguages.firstWhere((lang) => lang.id == id,
          orElse: () => LanguageModel(
              id: id, name: '', shortcut: '', emoji: '', asciiShortcut: ''));
      return UserLanguage(
        id: '',
        userId: _user.id,
        languageId: id,
        name: language.name,
        shortcut: language.shortcut,
        timestamp: DateTime.now(),
        level: 'Beginner',
        score: 0,
      );
    }).toList();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _user = _user.copyWith(
        sourceLanguageIds:
            _selectedNativeLanguages.map((l) => l.languageId).toList(),
        spokenLanguageIds:
            _selectedSpokenLanguages.map((l) => l.languageId).toList(),
        targetLanguageIds:
            _selectedTargetLanguages.map((l) => l.languageId).toList(),
        interests:
            _interestsController.text.split(',').map((e) => e.trim()).toList(),
        onboardingComplete: true
      );

      ref.read(signUpProvider.notifier).completeSignUp(_user);
    }
  }

  void _showLanguageSelector(String title, List<UserLanguage> selectedLanguages,
      bool isTargetLanguage, Function(List<UserLanguage>) onSelect) {
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
          isTargetLanguage: isTargetLanguage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsyncValue = ref.watch(currentUserProvider);

    return currentUserAsyncValue.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (user) {
          _user = user; // Safely assign the user here once data is available

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
                      onChanged: (value) =>
                          _user = _user.copyWith(location: value),
                    ),
                    CupertinoTextFormFieldRow(
                      prefix: const Text('Bio'),
                      initialValue: _user.bio,
                      onChanged: (value) => _user = _user.copyWith(bio: value),
                    ),
                    CupertinoTextFormFieldRow(
                      prefix: const Text('Interests'),
                      controller: _interestsController,
                      placeholder: 'Enter interests separated by commas',
                    ),
                    CupertinoTextFormFieldRow(
                      prefix: const Text('Occupation'),
                      initialValue: _user.occupation,
                      onChanged: (value) =>
                          _user = _user.copyWith(occupation: value),
                    ),
                    CupertinoTextFormFieldRow(
                      prefix: const Text('Education'),
                      initialValue: _user.education,
                      onChanged: (value) =>
                          _user = _user.copyWith(education: value),
                    ),
                    _buildLanguageBottomBar(),
                    _buildTargetLanguageLevels(),
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
        });
  }

  Widget _buildTargetLanguageLevels() {
    return Column(
      children: _selectedTargetLanguages.map((language) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(language.name),
            CupertinoSegmentedControl<String>(
              children: {
                'Beginner': Text('Beginner'),
                'Intermediate': Text('Intermediate'),
                'Advanced': Text('Advanced'),
              },
              groupValue: language.level,
              onValueChanged: (String value) {
                setState(() {
                  final index = _selectedTargetLanguages.indexOf(language);
                  _selectedTargetLanguages[index] =
                      language.copyWith(level: value);
                });
              },
            ),
          ],
        );
      }).toList(),
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
          _buildLanguageButton('Native', _selectedNativeLanguages, false),
          _buildLanguageButton('Spoken', _selectedSpokenLanguages, false),
          _buildLanguageButton('Target', _selectedTargetLanguages, true),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
      String title, List<UserLanguage> languages, bool isTargetLanguage) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          Text('${languages.length}',
              style:
                  TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
      onPressed: () {
        _showLanguageSelector(
          'Select $title Languages',
          languages,
          isTargetLanguage,
          (updatedLanguages) {
            setState(() {
              if (title == 'Native') {
                _selectedNativeLanguages = updatedLanguages;
              } else if (title == 'Spoken') {
                _selectedSpokenLanguages = updatedLanguages;
              } else if (title == 'Target') {
                _selectedTargetLanguages = updatedLanguages;
              }
            });
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
            child: Text(widget.title,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
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
                    final isSelected = _selectedLanguages
                        .any((l) => l.languageId == language.id);

                    return Column(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${language.emoji} ${language.name}'),
                              Icon(
                                isSelected
                                    ? CupertinoIcons.minus_circle
                                    : CupertinoIcons.plus_circle,
                                color: isSelected
                                    ? CupertinoColors.destructiveRed
                                    : CupertinoColors.activeBlue,
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                _selectedLanguages.removeWhere(
                                    (l) => l.languageId == language.id);
                              } else {
                                _selectedLanguages.add(UserLanguage(
                                  id: '',
                                  userId: '',
                                  languageId: language.id,
                                  name: language.name,
                                  shortcut: language.shortcut,
                                  timestamp: DateTime.now(),
                                  level: 'Beginner',
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
                            groupValue: _selectedLanguages
                                .firstWhere((l) => l.languageId == language.id)
                                .level,
                            onValueChanged: (String value) {
                              setState(() {
                                final index = _selectedLanguages.indexWhere(
                                    (l) => l.languageId == language.id);
                                _selectedLanguages[index] =
                                    _selectedLanguages[index]
                                        .copyWith(level: value);
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
              widget.onSelect(_selectedLanguages);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
