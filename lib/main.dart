import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lessay_learn/app.dart';
import 'package:lessay_learn/core/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 if (kIsWeb) {
    await Hive.initFlutter('hive_db');
  } else {
    await Hive.initFlutter();
  }
  await configureDependencies();
  runApp(ProviderScope(child: MyApp()));
}