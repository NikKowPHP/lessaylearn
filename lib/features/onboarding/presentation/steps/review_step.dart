// lib/features/onboarding/presentation/steps/review_step.dart

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class ReviewStep extends ConsumerWidget {
  final UserModel user;

  const ReviewStep({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilePictureAsync = ref.watch(profilePictureByIdProvider(user.avatarUrl));

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Review Your Profile', style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        const SizedBox(height: 16),
        _buildInfoRow('Name', user.name),
        _buildInfoRow('Email', user.email),
        _buildInfoRow('Age', user.age.toString()),
        _buildInfoRow('Location', user.location),
        _buildInfoRow('Native Languages', user.sourceLanguageIds.join(', ')),
        _buildInfoRow('Spoken Languages', user.spokenLanguageIds.join(', ')),
        _buildInfoRow('Target Languages', user.targetLanguageIds.join(', ')),
        _buildInfoRow('Interests', user.interests.join(', ')),
        const SizedBox(height: 16),
       
            profilePictureAsync.when(
          data: (profilePicture) {
            if (profilePicture != null) {
              Uint8List imageBytes = profilePicture.getImageBytes();
              return Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: MemoryImage(imageBytes), // Use MemoryImage to display the image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No profile picture available.'));
            }
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, stack) => Center(child: Text('Error loading profile picture: $e')),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}