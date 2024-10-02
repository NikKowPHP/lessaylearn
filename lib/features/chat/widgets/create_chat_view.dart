import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';


class CreateChatView extends StatefulWidget {
  final IChatService chatService;

  CreateChatView({Key? key, required this.chatService}) : super(key: key);

  @override
  _CreateChatViewState createState() => _CreateChatViewState();
}

class _CreateChatViewState extends State<CreateChatView> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _chatTopic = '';
  String _languageLevel = 'Beginner';
  String _sourceLanguage = '';
  String _targetLanguage = '';

  final List<String> _languageLevels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => context.go('/'),
        ),
        middle: Text('Create New Chat'),
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
                prefix: Text('Name'),
                placeholder: 'Enter chat name',
                onChanged: (value) => setState(() => _name = value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              CupertinoTextFormFieldRow(
                prefix: Text('Topic'),
                placeholder: 'Enter chat topic',
                onChanged: (value) => setState(() => _chatTopic = value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a topic' : null,
              ),
              CupertinoFormSection(
                header: Text('Language Settings'),
                children: [
                  CupertinoFormRow(
                    prefix: Text('Level'),
                    child: CupertinoPicker(
                      itemExtent: 32.0,
                      onSelectedItemChanged: (index) => setState(
                          () => _languageLevel = _languageLevels[index]),
                      children:
                          _languageLevels.map((level) => Text(level)).toList(),
                    ),
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: Text('Source'),
                    placeholder: 'Enter source language',
                    onChanged: (value) =>
                        setState(() => _sourceLanguage = value),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter source language' : null,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: Text('Target'),
                    placeholder: 'Enter target language',
                    onChanged: (value) =>
                        setState(() => _targetLanguage = value),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter target language' : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newChat = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        hostUserId: 'currentUserId', // Replace with actual current user ID
        guestUserId: '', // This will be empty for a new chat
        lastMessage: '',
        lastMessageTimestamp: DateTime.now(),
        chatTopic: _chatTopic,
        languageLevel: _languageLevel,
        sourceLanguage: _sourceLanguage,
        targetLanguage: _targetLanguage,
      );

      // await widget.chatService.createChat(newChat);
      context.go('/');
    }
  }
}
