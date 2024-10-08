// lib/features/onboarding/presentation/steps/language_selection_step.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/providers/language_provider.dart';

class LanguageSelectionStep extends ConsumerStatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdate;

  const LanguageSelectionStep({Key? key, required this.user, required this.onUpdate}) : super(key: key);

  @override
  _LanguageSelectionStepState createState() => _LanguageSelectionStepState();
}
class _LanguageSelectionStepState extends ConsumerState<LanguageSelectionStep> {
  List<UserLanguage> _nativeLanguages = [];
  List<UserLanguage> _spokenLanguages = [];
  List<UserLanguage> _targetLanguages = [];

  @override
  void initState() {
    super.initState();
    _initializeLanguages();
  }

  void _initializeLanguages() {
    final allLanguagesAsyncValue = ref.read(allLanguagesProvider);
    allLanguagesAsyncValue.whenData((languages) {
      setState(() {
        _nativeLanguages = _createUserLanguages(widget.user.sourceLanguageIds, languages);
        _spokenLanguages = _createUserLanguages(widget.user.spokenLanguageIds, languages);
        _targetLanguages = _createUserLanguages(widget.user.targetLanguageIds, languages);
      });
    });
  }


  List<UserLanguage> _createUserLanguages(List<String> languageIds, List<LanguageModel> allLanguages) {
    return languageIds.map((id) {
      final language = allLanguages.firstWhere((lang) => lang.id == id,
          orElse: () => LanguageModel(id: id, name: '', shortcut: '', emoji: '', asciiShortcut: ''));
      return UserLanguage(
        id: '',
        userId: widget.user.id,
        languageId: id,
        name: language.name,
        shortcut: language.shortcut,
        timestamp: DateTime.now(),
        level: 'Beginner',
        score: 0,
      );
    }).toList();
  }

  void _updateUser() {
    final updatedUser = widget.user.copyWith(
      sourceLanguageIds: _nativeLanguages.map((l) => l.languageId).toList(),
      spokenLanguageIds: _spokenLanguages.map((l) => l.languageId).toList(),
      targetLanguageIds: _targetLanguages.map((l) => l.languageId).toList(),
    );
    widget.onUpdate(updatedUser);
  }
  @override
  Widget build(BuildContext context) {
    // Remove the null check since the lists are now initialized
    return Column(
      children: [
        _buildLanguageSection('Native Languages', _nativeLanguages, (languages) {
          setState(() => _nativeLanguages = languages);
          _updateUser();
        }, false),
        _buildLanguageSection('Spoken Languages', _spokenLanguages, (languages) {
          setState(() => _spokenLanguages = languages);
          _updateUser();
        }, false),
        _buildLanguageSection('Target Languages', _targetLanguages, (languages) {
          setState(() => _targetLanguages = languages);
          _updateUser();
        }, true),
        _buildTargetLanguageLevels(),
      ],
    );
  }


  Widget _buildLanguageSection(String title, List<UserLanguage> languages, Function(List<UserLanguage>) onUpdate, bool isTargetLanguage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ...languages.map((lang) => _buildLanguageChip(lang)),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add_circled),
              onPressed: () => _showLanguageSelector(title, languages, isTargetLanguage, onUpdate),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLanguageChip(UserLanguage language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(language.name),
    );
  }

  void _showLanguageSelector(String title, List<UserLanguage> selectedLanguages, bool isTargetLanguage, Function(List<UserLanguage>) onUpdate) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LanguageSelectorSheet(
          title: title,
          selectedLanguages: selectedLanguages,
          onSelect: (updatedLanguages) {
            setState(() {
              onUpdate(updatedLanguages);
            });
          },
          isTargetLanguage: isTargetLanguage,
        );
      },
    );
  }

   Widget _buildTargetLanguageLevels() {
    // Remove the null check and '?' operator
    return Column(
      children: _targetLanguages.map((language) {
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
                  final index = _targetLanguages.indexOf(language);
                  _targetLanguages[index] = language.copyWith(level: value);
                });
                _updateUser();
              },
            ),
          ],
        );
      }).toList(),
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
