// lib/features/onboarding/presentation/steps/basic_info_step.dart

import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class BasicInfoStep extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdate;

  const BasicInfoStep({Key? key, required this.user, required this.onUpdate}) : super(key: key);

  @override
  _BasicInfoStepState createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
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
      ],
    );
  }
}