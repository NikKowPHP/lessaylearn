import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';

class CreateChatView extends ConsumerStatefulWidget {
  CreateChatView({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateChatView> createState() => _CreateChatViewState();
}

class _CreateChatViewState extends ConsumerState<CreateChatView> {
  final _formKey = GlobalKey<FormState>();
  String _aiName = '';
  String _chatTopic = '';
  String _languageLevel = 'Beginner';
  String _sourceLanguage = '';
  String _targetLanguage = '';
  int _aiAge = 25;
  String _aiOccupation = '';
  List<String> _aiInterests = [];
  List<String> _personalityTraits = [];
  List<String> _bioTags = [];

  final List<String> _languageLevels = ['Beginner', 'Intermediate', 'Advanced', 'Native'];
  final List<String> _personalityOptions = [
    'Friendly', 'Professional', 'Humorous', 'Strict', 'Patient', 'Empathetic',
    'Analytical', 'Creative', 'Motivational', 'Calm', 'Enthusiastic', 'Sarcastic'
  ];
  final List<String> _interestOptions = [
    'Travel', 'Music', 'Sports', 'Technology', 'Cooking', 'Literature', 'Movies',
    'Art', 'Science', 'History', 'Philosophy', 'Photography', 'Nature', 'Fashion'
  ];
  final List<String> _bioTagOptions = [
    'Language enthusiast', 'Cultural explorer', 'Grammar nerd', 'Conversation starter',
    'Idiom expert', 'Pronunciation coach', 'Vocabulary builder', 'Writing mentor',
    'Reading companion', 'Debate partner', 'Storyteller', 'Global citizen'
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
       backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Create AI Language Partner'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Create'),
          onPressed: _submitForm,
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              CupertinoTextFormFieldRow(
                prefix: Text('AI Name'),
                placeholder: 'Enter AI partner name',
                onChanged: (value) => setState(() => _aiName = value),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              CupertinoTextFormFieldRow(
                prefix: Text('Chat Topic'),
                placeholder: 'Enter chat topic',
                onChanged: (value) => setState(() => _chatTopic = value),
                validator: (value) => value!.isEmpty ? 'Please enter a topic' : null,
              ),
              _buildLanguageSettings(),
              _buildAIProfile(),
              _buildTagSection('Personality Traits', _personalityTraits, _personalityOptions),
              _buildTagSection('AI Interests', _aiInterests, _interestOptions),
              _buildTagSection('Bio Tags', _bioTags, _bioTagOptions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return CupertinoFormSection(
      header: Text('Language Settings'),
      children: [
        CupertinoFormRow(
          prefix: Text('Level'),
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (index) => setState(() => _languageLevel = _languageLevels[index]),
            children: _languageLevels.map((level) => Text(level)).toList(),
          ),
        ),
        CupertinoTextFormFieldRow(
          prefix: Text('Source Language'),
          placeholder: 'Enter source language',
          onChanged: (value) => setState(() => _sourceLanguage = value),
          validator: (value) => value!.isEmpty ? 'Please enter source language' : null,
        ),
        CupertinoTextFormFieldRow(
          prefix: Text('Target Language'),
          placeholder: 'Enter target language',
          onChanged: (value) => setState(() => _targetLanguage = value),
          validator: (value) => value!.isEmpty ? 'Please enter target language' : null,
        ),
      ],
    );
  }

  Widget _buildAIProfile() {
    return CupertinoFormSection(
      header: Text('AI Partner Profile'),
      children: [
        CupertinoFormRow(
          prefix: Text('Age'),
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (index) => setState(() => _aiAge = index + 18),
            children: List.generate(63, (index) => Text('${index + 18}')),
          ),
        ),
        CupertinoTextFormFieldRow(
          prefix: Text('Occupation'),
          placeholder: 'Enter AI occupation',
          onChanged: (value) => setState(() => _aiOccupation = value),
        ),
      ],
    );
  }

  Widget _buildTagSection(String title, List<String> selectedTags, List<String> allOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedTags.map((tag) => _buildTagChip(tag, selectedTags)).toList(),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Add ${title.toLowerCase()}'),
          onPressed: () => _showBottomSheet(context, title, selectedTags, allOptions),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag, List<String> selectedTags) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag, style: TextStyle(fontSize: 14)),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () => setState(() => selectedTags.remove(tag)),
            child: Icon(CupertinoIcons.xmark_circle_fill, size: 18, color: CupertinoColors.systemGrey3),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String title, List<String> selectedTags, List<String> allOptions) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Expanded(
                child: CupertinoScrollbar(
                  child: ListView(
                    children: allOptions.map((option) => _buildTagTile(option, selectedTags)).toList(),
                  ),
                ),
              ),
              CupertinoButton(
                child: Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildTagTile(String tag, List<String> selectedTags) {
    final isSelected = selectedTags.contains(tag);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tag),
          Icon(
            isSelected ? CupertinoIcons.minus_circle : CupertinoIcons.plus_circle,
            color: isSelected ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
          ),
        ],
      ),
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedTags.remove(tag);
          } else {
            selectedTags.add(tag);
          }
        });
        Navigator.of(context).pop();
        _showBottomSheet(context, tag, selectedTags, selectedTags == _personalityTraits ? _personalityOptions : _interestOptions);
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null) {
        _showErrorDialog('Unable to create chat. Please try again later.');
        return;
      }

      final promptString = _generatePromptString();
      final bio = await _generateBioUsingAI(promptString);

      final aiUser = UserModel(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        name: _aiName,
        email: 'ai@example.com',
        avatarUrl: 'assets/ai_avatar.png',
        languageLevel: _languageLevel,
        sourceLanguageIds: [_sourceLanguage],
        targetLanguageIds: [_targetLanguage],
        spokenLanguageIds: [_sourceLanguage, _targetLanguage],
        location: 'AI World',
        age: _aiAge,
        bio: bio,
        interests: _aiInterests,
        occupation: _aiOccupation,
        education: 'AI Training',
        languageIds: [_sourceLanguage, _targetLanguage],
      );

      await ref.read(userServiceProvider).createUser(aiUser);

      final newChat = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        hostUserId: currentUser.id,
        guestUserId: aiUser.id,
        lastMessage: '',
        lastMessageTimestamp: DateTime.now(),
        chatTopic: _chatTopic,
        languageLevel: _languageLevel,
        sourceLanguage: _sourceLanguage,
        targetLanguage: _targetLanguage,
        isAi: true,
      );

      await ref.read(chatServiceProvider).createChat(newChat);
      ref.read(chatsProvider.notifier).addChat(newChat);
      context.go('/');
    }
  }

  String _generatePromptString() {
    final promptParts = [
      "Create a bio for an AI language learning partner with the following characteristics:",
      "Name: $_aiName",
      "Age: $_aiAge",
      "Occupation: $_aiOccupation",
      "Personality traits: ${_personalityTraits.join(', ')}",
      "Interests: ${_aiInterests.join(', ')}",
      "Language level: $_languageLevel",
      "Source language: $_sourceLanguage",
      "Target language: $_targetLanguage",
      "Bio tags: ${_bioTags.join(', ')}",
      "The bio should be friendly, engaging, and highlight the AI's role as a language learning partner.",
      "It should incorporate the personality traits, interests, and bio tags in a natural way.",
      "The bio should be about 3-4 sentences long and written in first person.",
    ];

    return promptParts.join("\n");
  }

  Future<String> _generateBioUsingAI(String promptString) async {
    // This is a placeholder. In a real application, you would send the promptString
    // to your AI service (e.g., OpenAI's GPT) and receive a generated bio.
    // For now, we'll return a dummy bio.
    await Future.delayed(Duration(seconds: 2)); // Simulating API call
    return "Hello! I'm $_aiName, a $_aiAge-year-old $_aiOccupation and your AI language partner. "
           "As someone who's ${_personalityTraits.take(2).join(' and ')}, I love discussing "
           "${_aiInterests.take(2).join(' and ')}. Let's improve your $_targetLanguage skills together!";
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}