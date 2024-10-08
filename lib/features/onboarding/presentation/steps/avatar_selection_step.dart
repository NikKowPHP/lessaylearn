// lib/features/onboarding/presentation/steps/avatar_selection_step.dart

import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class AvatarSelectionStep extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdate;

  const AvatarSelectionStep({Key? key, required this.user, required this.onUpdate}) : super(key: key);

  @override
  _AvatarSelectionStepState createState() => _AvatarSelectionStepState();
}

class _AvatarSelectionStepState extends State<AvatarSelectionStep> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.user.avatarUrl;
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Here you would typically upload the image to your server and get a URL back
      // For this example, we'll just use the local path
      setState(() {
        _avatarUrl = image.path;
      });
      _updateUser();
    }
  }

  void _updateUser() {
    final updatedUser = widget.user.copyWith(avatarUrl: _avatarUrl);
    widget.onUpdate(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Choose your avatar', style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.systemGrey5,
                image: _avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _avatarUrl == null
                  ? const Icon(CupertinoIcons.person_add, size: 50, color: CupertinoColors.systemGrey)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          CupertinoButton(
            child: const Text('Select Image'),
            onPressed: _pickImage,
          ),
        ],
      ),
    );
  }
}