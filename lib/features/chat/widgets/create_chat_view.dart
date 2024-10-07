import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/core/providers/user_language_provider.dart';
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
  bool _isLoading = false;
  String _languageLevel = 'Beginner';
  String _sourceLanguage = '';
  String _targetLanguage = '';
  int _aiAge = 25;
  List<String> _personalityTraits = [];
  List<String> _aiInterests = [];
  List<String> _bioTags = [];
  String _generatedName = '';
  String _generatedOccupation = '';
  String _generatedChatTopic = '';
  String _generatedBio = '';
  String _generatedLocation = ''; // New variable
  String _generatedEducation = ''; // New variable
  UserLanguage? _preferredLanguage;
  UserLanguage? _studyLanguage;
  List<UserLanguage> _availableLanguages = [];

  final List<String> _languageLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Native'
  ];
  final List<String> _personalityOptions = [
    'Friendly',
    'Professional',
    'Humorous',
    'Strict',
    'Patient',
    'Empathetic',
    'Analytical',
    'Creative',
    'Motivational',
    'Calm',
    'Enthusiastic',
    'Sarcastic'
  ];
  final List<String> _interestOptions = [
    'Travel',
    'Music',
    'Sports',
    'Technology',
    'Cooking',
    'Literature',
    'Movies',
    'Art',
    'Science',
    'History',
    'Philosophy',
    'Photography',
    'Nature',
    'Fashion'
  ];
  final List<String> _bioTagOptions = [
    'Language enthusiast',
    'Cultural explorer',
    'Grammar nerd',
    'Conversation starter',
    'Idiom expert',
    'Pronunciation coach',
    'Vocabulary builder',
    'Writing mentor',
    'Reading companion',
    'Debate partner',
    'Storyteller',
    'Global citizen'
  ];

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return Center(child: Text('User not found'));
        }
        return FutureBuilder<List<UserLanguage>>(
          future: _fetchUserLanguages(currentUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading languages'));
            }
            _availableLanguages = snapshot.data ?? [];
            return _buildPageContent(currentUser);
          },
        );
      },
      loading: () => Center(child: CupertinoActivityIndicator()),
      error: (_, __) => Center(child: Text('Error loading user')),
    );
  }

  Widget _buildPageContent(UserModel currentUser) {
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
              _buildSectionTitle('Language Settings'),
              _buildLanguageSettings(currentUser),
              _buildSectionTitle('AI Partner Profile'),
              _buildAIProfile(),
              _buildSectionTitle('Personality Traits'),
              _buildTagSection('Personality Traits', _personalityTraits,
                  _personalityOptions),
              _buildSectionTitle('AI Interests'),
              _buildTagSection('AI Interests', _aiInterests, _interestOptions),
              _buildSectionTitle('Bio Tags'),
              _buildTagSection('Bio Tags', _bioTags, _bioTagOptions),
              _buildGeneratedProfileSection(), // New section for generated profile
              _buildGenerateProfileButton(), // New button to generate profile
            ],
          ),
        ),
      ),
    );
  }

  Future<List<UserLanguage>> _fetchUserLanguages(UserModel user) async {
    final sourceLanguageFutures = user.sourceLanguageIds
        .map((id) => ref.read(userLanguageByIdProvider(id).future));
    final targetLanguageFutures = user.targetLanguageIds
        .map((id) => ref.read(userLanguageByIdProvider(id).future));

    final allLanguageFutures = [
      ...sourceLanguageFutures,
      ...targetLanguageFutures
    ];

    final languages = await Future.wait(allLanguageFutures);
    debugPrint('languages $languages');

    return languages.whereType<UserLanguage>().toList();
  }

  // New method to build the generated profile section
  Widget _buildGeneratedProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Generated AI Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (_isLoading) // Show loading indicator if loading
            Center(child: CupertinoActivityIndicator())
          else ...[
            Text('Name: $_generatedName'),
            Text('Occupation: $_generatedOccupation'),
            Text('Chat Topic: $_generatedChatTopic'),
            Text('Bio: $_generatedBio'),
            Text('Location: $_generatedLocation'), // New field
            Text('Education: $_generatedEducation'), // New field
          ],
        ],
      ),
    );
  }

  // New method to build the generate profile button
  Widget _buildGenerateProfileButton() {
    return CupertinoButton(
      color: CupertinoColors.activeBlue,
      child: Text('Generate Profile'),
      onPressed: _generateProfile,
    );
  }

  // New method to generate the AI profile
  void _generateProfile() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    final promptString = _generatePromptString();
    final aiData = await _generateAIDataUsingAI(promptString);

    setState(() {
      _generatedName = aiData.name;
      _generatedOccupation = aiData.occupation;
      _generatedChatTopic = aiData.chatTopic;
      _generatedBio = aiData.bio;
      _generatedLocation = aiData.location; // New field
      _generatedEducation = aiData.education; // New field
    });
    _isLoading = false;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLanguageSettings(UserModel currentUser) {
    return CupertinoFormSection(
      children: [
        CupertinoFormRow(
          prefix: Text('Your Preferred Language'),
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (index) {
              setState(() {
                _preferredLanguage = _availableLanguages[index];
              });
            },
            children:
                _availableLanguages.map((lang) => Text(lang.name)).toList(),
          ),
        ),
        CupertinoFormRow(
          prefix: Text('Study Language'),
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (index) {
              setState(() {
                _studyLanguage = _availableLanguages[index];
              });
            },
            children:
                _availableLanguages.map((lang) => Text(lang.name)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAIProfile() {
    return CupertinoFormSection(
      children: [
        CupertinoFormRow(
          prefix: Text('Age'),
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (index) =>
                setState(() => _aiAge = index + 18),
            children: List.generate(63, (index) => Text('${index + 18}')),
          ),
        ),
      ],
    );
  }

  Widget _buildTagSection(
      String title, List<String> selectedTags, List<String> allOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedTags
              .map((tag) => _buildTagChip(tag, selectedTags))
              .toList(),
        ),
        SizedBox(height: 16),
        CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.circular(20),
          child: Text('Add ${title.toLowerCase()}',
              style: TextStyle(color: CupertinoColors.white)),
          onPressed: () =>
              _showBottomSheet(context, title, selectedTags, allOptions),
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
            child: Icon(CupertinoIcons.xmark_circle_fill,
                size: 18, color: CupertinoColors.systemGrey3),
          ),
        ],
      ),
    );
  }

void _showBottomSheet(BuildContext context, String title,
    List<String> selectedTags, List<String> allOptions) {
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
            Text(title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: CupertinoScrollbar(
                child: ListView(
                  primary: true, // Use the PrimaryScrollController
                  children: allOptions
                      .map((option) =>
                          _buildTagTile(option, selectedTags, allOptions))
                      .toList(),
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

  String _getTitleForTags(List<String> tags) {
    if (tags == _personalityTraits) return 'Personality Traits';
    if (tags == _aiInterests) return 'AI Interests';
    if (tags == _bioTags) return 'Bio Tags';
    return '';
  }

  Widget _buildTagTile(
      String tag, List<String> selectedTags, List<String> allOptions) {
    final isSelected = selectedTags.contains(tag);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tag),
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
            selectedTags.remove(tag);
          } else {
            selectedTags.add(tag);
          }
        });
        Navigator.of(context).pop();
        _showBottomSheet(
            context, _getTitleForTags(selectedTags), selectedTags, allOptions);
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null ||
          _preferredLanguage == null ||
          _studyLanguage == null) {
        _showErrorDialog('Unable to create chat. Please try again later.');
        return;
      }

      final promptString = _generatePromptString();
      final aiData = await _generateAIDataUsingAI(promptString);

      final aiUser = UserModel(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        name: aiData.name,
        email: 'ai@example.com',
        avatarUrl: 'assets/ai_avatar.png',
        languageLevel: _languageLevel,
        sourceLanguageIds: [_preferredLanguage!.id],
        targetLanguageIds: [_studyLanguage!.id],
        spokenLanguageIds: [_preferredLanguage!.id, _studyLanguage!.id],
        location: aiData.location,
        age: _aiAge,
        bio: aiData.bio,
        interests: _aiInterests,
        occupation: aiData.occupation,
        education: aiData.education,
        languageIds: [_preferredLanguage!.id, _studyLanguage!.id],
      );

      await ref.read(userServiceProvider).createUser(aiUser);

      final newChat = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        hostUserId: currentUser.id,
        guestUserId: aiUser.id,
        lastMessage: '',
        lastMessageTimestamp: DateTime.now(),
        chatTopic: aiData.chatTopic,
        languageLevel: _languageLevel,
        sourceLanguageId: _sourceLanguage,
        targetLanguageId: _targetLanguage,
        isAi: true,
      );

      await ref.read(chatServiceProvider).createChat(newChat);
      ref.read(chatsProvider.notifier).addChat(newChat);
      context.go('/');
    }
  }

  String _generatePromptString() {
    final promptParts = [
      "Create an AI language learning partner with the following characteristics:",
      "Age: $_aiAge",
      "Personality traits: ${_personalityTraits.join(', ')}",
      "Interests: ${_aiInterests.join(', ')}",
      "Language level: $_languageLevel",
      "Source language: $_sourceLanguage",
      "Target language: $_targetLanguage",
      "Bio tags: ${_bioTags.join(', ')}",
      "Generate a name, occupation, chat topic, and bio for this AI partner.",
      "The bio should be friendly, engaging, and highlight the AI's role as a language learning partner.",
      "It should incorporate the personality traits, interests, and bio tags in a natural way.",
      "The bio should be about 3-4 sentences long and written in first person.",
    ];

    return promptParts.join("\n");
  }

  Future<AIData> _generateAIDataUsingAI(String promptString) async {
    // This is a placeholder. In a real application, you would send the promptString
    // to your AI service (e.g., OpenAI's GPT) and receive generated data.
    // For now, we'll return dummy data.
    await Future.delayed(Duration(seconds: 2)); // Simulating API call

    final AIData aiData = AIData(
      name: "Alex",
      occupation: "Language Tutor",
      chatTopic: "Cultural Exchange",
      bio:
          "Hi, I'm Alex, a $_aiAge-year-old language enthusiast and your AI language partner. "
          "As someone who's ${_personalityTraits.take(2).join(' and ')}, I love discussing "
          "${_aiInterests.take(2).join(' and ')}. Let's explore $_targetLanguage together "
          "while sharing our cultural experiences!",
      location: "AI World",
      education: "AI Training",
    );
    return aiData;
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

class AIData {
  final String name;
  final String occupation;
  final String chatTopic;
  final String bio;
  final String location;
  final String education;

  AIData({
    required this.name,
    required this.occupation,
    required this.chatTopic,
    required this.bio,
    required this.location,
    required this.education,
  });

  // Factory method to create an instance from a map
  factory AIData.fromMap(Map<String, String> map) {
    return AIData(
      name: map['name'] ?? '',
      occupation: map['occupation'] ?? '',
      chatTopic: map['chatTopic'] ?? '',
      bio: map['bio'] ?? '',
      location: map['location'] ?? '',
      education: map['education'] ?? '',
    );
  }
}
