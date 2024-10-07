import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/providers/sign_up_provider.dart';
import 'package:lessay_learn/core/models/language_model.dart';
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

  void _showLanguageSelector(String title, List<String> selectedLanguages,
      Function(List<String>) onSelect) {
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
          _buildLanguageButton('Native', _user.sourceLanguageIds),
          _buildLanguageButton('Spoken', _user.spokenLanguageIds),
          _buildLanguageButton('Target', _user.targetLanguageIds),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String title, List<String> languageIds) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          Text('${languageIds.length}',
              style:
                  TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
        ],
      ),
      onPressed: () => _showLanguageSelector(
        'Select $title Languages',
        languageIds,
        (languages) => setState(() {
          if (title == 'Native') {
            _user = _user.copyWith(sourceLanguageIds: languages);
          } else if (title == 'Spoken') {
            _user = _user.copyWith(spokenLanguageIds: languages);
          } else if (title == 'Target') {
            _user = _user.copyWith(targetLanguageIds: languages);
          }
        }),
      ),
    );
  }
}

class LanguageSelectorSheet extends ConsumerStatefulWidget {
  final String title;
  final List<String> selectedLanguages;
  final Function(List<String>) onSelect;

  const LanguageSelectorSheet({
    Key? key,
    required this.title,
    required this.selectedLanguages,
    required this.onSelect,
  }) : super(key: key);

  @override
  _LanguageSelectorSheetState createState() => _LanguageSelectorSheetState();
}

class _LanguageSelectorSheetState extends ConsumerState<LanguageSelectorSheet> {
  late List<String> _selectedLanguages;
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
                    final isSelected = _selectedLanguages.contains(language.id);
                    return CupertinoButton(
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
                            _selectedLanguages.remove(language.id);
                          } else {
                            _selectedLanguages.add(language.id);
                          }
                        });
                        widget.onSelect(_selectedLanguages);
                      },
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
