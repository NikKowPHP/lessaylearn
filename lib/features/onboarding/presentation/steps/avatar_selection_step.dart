import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/onboarding/providers/onboarding_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AvatarSelectionStep extends ConsumerStatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdate;

  const AvatarSelectionStep(
      {Key? key, required this.user, required this.onUpdate})
      : super(key: key);

  @override
  _AvatarSelectionStepState createState() => _AvatarSelectionStepState();
}

class _AvatarSelectionStepState extends ConsumerState<AvatarSelectionStep> {
  String? _avatarUrl;

  void initState() {
    super.initState();
    _avatarUrl = ref.read(onboardingUserProvider).avatarUrl;
  }

  Future<void> _pickImage() async {
    dynamic pickedImage;
    if (kIsWeb) {
    // Web implementation using file_picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      // For web, we'll skip compression and use the original image
      pickedImage = 'data:image/png;base64,${base64Encode(fileBytes)}';
    }
    } else {
      // Mobile implementation
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final dir = await path_provider.getTemporaryDirectory();
        final targetPath =
            '${dir.absolute.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File(image.path);

        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          file.path,
          targetPath,
          minHeight: 500,
          minWidth: 500,
          quality: 85,
        );

        if (compressedFile != null) {
          final compressedBytes = await compressedFile.readAsBytes();
          pickedImage =
              'data:image/jpeg;base64,${base64Encode(compressedBytes)}'; // Encode to base64
        }
      }
    }

    if (pickedImage != null) {
      final onboardingService = ref.read(onboardingServiceProvider);
      final avatarUrl = await onboardingService.saveAvatarLocally(pickedImage);
      setState(() {
        _avatarUrl = avatarUrl;
      });
      ref.read(onboardingUserProvider.notifier).updateAvatar(avatarUrl);
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
    if (kIsWeb) {
      final String dataUrl = _avatarUrl!;
      if (!dataUrl.contains(',')) {
        // Invalid data URL format
        return AssetImage('assets/blank.png');
      }
      final String base64String = dataUrl.split(',').last;
      final Uint8List bytes = base64Decode(base64String);
      if (bytes.isEmpty) {
        // Empty image data
        return AssetImage('assets/blank.png');
      }
      return MemoryImage(bytes);
    } else {
      final file = File(_avatarUrl!);
      if (!file.existsSync()) {
        // File doesn't exist
        return AssetImage('assets/blank.png');
      }
      return FileImage(file);
    }
  }
}
