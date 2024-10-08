// lib/features/onboarding/presentation/onboarding_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/onboarding/presentation/steps/basic_info_step.dart';
import 'package:lessay_learn/features/onboarding/presentation/steps/language_selection_step.dart';
import 'package:lessay_learn/features/onboarding/presentation/steps/interests_step.dart';
import 'package:lessay_learn/features/onboarding/presentation/steps/avatar_selection_step.dart';
import 'package:lessay_learn/features/onboarding/presentation/steps/review_step.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/core/auth/providers/sign_up_provider.dart';
import 'package:lessay_learn/features/onboarding/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final UserModel initialUser;

  const OnboardingScreen({Key? key, required this.initialUser}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  late UserModel _user;
  int _currentStep = 0;
  final int _totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _user = widget.initialUser;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSignUp();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateUser(UserModel updatedUser) {
    setState(() {
      _user = updatedUser;
    });
    ref.read(onboardingUserProvider.notifier).updateUser(updatedUser);
  }

 void _completeSignUp() async {
    final onboardingService = ref.read(onboardingServiceProvider);
    try {
      await onboardingService.completeRegistration(_user);
      ref.read(signUpProvider.notifier).completeSignUp(_user);
      // Navigate to the main app screen or show a completion message
    } catch (e) {
      // Handle error (e.g., show an error message)
      print('Error completing sign up: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Step ${_currentStep + 1} of $_totalSteps'),
        leading: _currentStep > 0
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.back),
                onPressed: _previousStep,
              )
            : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  BasicInfoStep(user: _user, onUpdate: _updateUser),
                  LanguageSelectionStep(user: _user, onUpdate: _updateUser),
                  InterestsStep(user: _user, onUpdate: _updateUser),
                  AvatarSelectionStep(user: _user, onUpdate: _updateUser),
                  ReviewStep(user: _user),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                child: Text(_currentStep == _totalSteps - 1 ? 'Complete' : 'Next'),
                onPressed: _nextStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}