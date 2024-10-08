// lib/features/onboarding/presentation/steps/review_step.dart

import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class ReviewStep extends StatelessWidget {
  final UserModel user;

  const ReviewStep({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
       
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(user.avatarUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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