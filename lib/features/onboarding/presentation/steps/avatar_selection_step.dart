// lib/features/onboarding/presentation/steps/avatar_selection_step.dart

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class AvatarSelectionStep extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdate;

  const AvatarSelectionStep(
      {Key? key, required this.user, required this.onUpdate})
      : super(key: key);

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
    if (kIsWeb) {
      // Web implementation using file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        Uint8List fileBytes = result.files.first.bytes!;
        String base64Image = base64Encode(fileBytes);
        setState(() {
          _avatarUrl = 'data:image/png;base64,$base64Image';
        });
        _updateUser();
      }
    } else {
      // Mobile implementation
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _avatarUrl = image.path;
        });
        _updateUser();
      }
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
          Text('Choose your avatar',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
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
                        image: _getImageProvider(),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _avatarUrl == null
                  ? const Icon(CupertinoIcons.person_add,
                      size: 50, color: CupertinoColors.systemGrey)
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

  ImageProvider _getImageProvider() {
    if (_avatarUrl!.startsWith('data:image')) {
      // For web (base64 image)
      return MemoryImage(base64Decode(_avatarUrl!.split(',').last));
    } else {
      // For mobile (file path)
      return FileImage(File(_avatarUrl!));
    }
  }
}
