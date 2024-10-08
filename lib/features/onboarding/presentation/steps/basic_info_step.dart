// lib/features/onboarding/presentation/steps/basic_info_step.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/onboarding/providers/onboarding_provider.dart';

class BasicInfoStep extends ConsumerStatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdate;

  const BasicInfoStep({Key? key, required this.user, required this.onUpdate}) : super(key: key);

  @override
  _BasicInfoStepState createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends ConsumerState<BasicInfoStep> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _ageController = TextEditingController(text: widget.user.age.toString());
    _locationController = TextEditingController(text: widget.user.location);
  
  }

  Future<void> _getUserLocation(WidgetRef ref) async {
    final onboardingService = ref.read(onboardingServiceProvider);
    final city = await onboardingService.getUserCity();
    if (city != null && mounted) {
      setState(() {
        _locationController.text = city;
      });
      _updateUser();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _updateUser() {
    final updatedUser = widget.user.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      location: _locationController.text,
    );
    widget.onUpdate(updatedUser);
  }

  @override
 Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        CupertinoTextField(
          controller: _nameController,
          placeholder: 'Name',
          onChanged: (_) => _updateUser(),
        ),
       
     
        const SizedBox(height: 16),
        CupertinoTextField(
          controller: _ageController,
          placeholder: 'Age',
          keyboardType: TextInputType.number,
          onChanged: (_) => _updateUser(),
        ),
        const SizedBox(height: 16),
        CupertinoTextField(
          controller: _locationController,
          placeholder: 'Location',
          onChanged: (_) => _updateUser(),
        ),
          const SizedBox(height: 8),
        CupertinoButton(
          child: Text('Get Current Location'),
         onPressed: () => _getUserLocation(ref),
        ),
      ],
    );
  }
}