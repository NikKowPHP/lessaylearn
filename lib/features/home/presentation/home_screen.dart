import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/dependency_injection.dart';
import 'package:lessay_learn/services/api_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = getIt<ApiService>(); // Access API service

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home Screen'),
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: () {
            // Call API service method
            apiService.fetchData(); 
          },
          child: const Text('Fetch Data'),
        ),
      ),
    );
  }
}
