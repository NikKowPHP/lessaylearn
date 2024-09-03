import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/app.dart';
import 'package:lessay_learn/core/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dependency Injection
  await configureDependencies();

  // Initialize Hive (if using)
  // await Hive.initFlutter(); 

  runApp(
     ProviderScope(
      child: MyApp(),
    ),
  );
}