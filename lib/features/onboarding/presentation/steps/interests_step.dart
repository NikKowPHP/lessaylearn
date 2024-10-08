// lib/features/onboarding/presentation/steps/interests_step.dart

import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class InterestsStep extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdate;

  const InterestsStep({Key? key, required this.user, required this.onUpdate}) : super(key: key);

  @override
  _InterestsStepState createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep> {
  late TextEditingController _interestsController;

  @override
  void initState() {
    super.initState();
    _interestsController = TextEditingController(text: widget.user.interests.join(', '));
  }

  @override
  void dispose() {
    _interestsController.dispose();
    super.dispose();
  }

  void _updateUser() {
    final updatedUser = widget.user.copyWith(
      interests: _interestsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    );
    widget.onUpdate(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('What are your interests?', style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        const SizedBox(height: 16),
        CupertinoTextField(
          controller: _interestsController,
          placeholder: 'Enter interests separated by commas',
          maxLines: 3,
          onChanged: (_) => _updateUser(),
        ),
        const SizedBox(height: 16),
        Text('Some examples: reading, traveling, cooking, photography, etc.', style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey)),
      ],
    );
  }
}