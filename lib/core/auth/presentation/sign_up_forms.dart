import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/auth/providers/sign_up_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

class SignUpFormsScreen extends ConsumerStatefulWidget {
  final UserModel initialUser;

  const SignUpFormsScreen({Key? key, required this.initialUser}) : super(key: key);

  @override
  _SignUpFormsScreenState createState() => _SignUpFormsScreenState();
}

class _SignUpFormsScreenState extends ConsumerState<SignUpFormsScreen> {
  late UserModel _user;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref.read(signUpProvider.notifier).completeSignUp(_user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Complete Your Profile'),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CupertinoTextFormFieldRow(
                prefix: const Text('Name'),
                initialValue: _user.name,
                onChanged: (value) => _user = _user.copyWith(name: value),
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              CupertinoTextFormFieldRow(
                prefix: const Text('Age'),
                initialValue: _user.age.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => _user = _user.copyWith(age: int.tryParse(value) ?? 0),
                validator: (value) => int.tryParse(value!) == null ? 'Invalid age' : null,
              ),
              CupertinoTextFormFieldRow(
                prefix: const Text('Location'),
                initialValue: _user.location,
                onChanged: (value) => _user = _user.copyWith(location: value),
              ),
              CupertinoTextFormFieldRow(
                prefix: const Text('Bio'),
                initialValue: _user.bio,
                onChanged: (value) => _user = _user.copyWith(bio: value),
              ),
              // Add more fields as needed

              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text('Complete Sign Up'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}