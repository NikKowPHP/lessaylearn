import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lessay_learn/app.dart';
import 'package:lessay_learn/core/app_config.dart';
import 'package:lessay_learn/core/dependency_injection.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/router/router.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();

//  await Firebase.initializeApp(); 
// Initialize Hive
  await Hive.initFlutter();

  // Initialize dependencies
  await configureDependencies();
  runApp(ProviderScope(child: LessayLearn()));
}
   

class LessayLearn extends ConsumerWidget {
 const LessayLearn({super.key});

   @override
  Widget build(BuildContext context, WidgetRef ref) {
   final appConfig = getIt<IAppConfig>(); 
    final router = ref.watch(routerProvider); // Get the router from the provider

    return CupertinoApp.router(
      title: appConfig.title,
      theme: appConfig.theme,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}