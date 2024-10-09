import 'package:flutter_test/flutter_test.dart';
import 'package:lessay_learn/core/widgets/cupertino_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/core/dependency_injection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lessay_learn/services/api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockPathProvider = MockPathProviderPlatform();
  PathProviderPlatform.instance = mockPathProvider;

  when(() => mockPathProvider.getApplicationDocumentsPath())
      .thenAnswer((_) async => '/tmp/test');

  await Hive.initFlutter('/tmp/test');
  await configureDependencies();

  test('App initialization runs without errors', () {
    expect(() {
      WidgetsFlutterBinding.ensureInitialized();
      Hive.initFlutter('/tmp/test');
      configureDependencies();
    }, returnsNormally);
  });

  testWidgets('MyApp widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.byType(CupertinoBottomNavBar), findsOneWidget);
  });


  testWidgets('MyApp is wrapped with ProviderScope',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );
    expect(find.byType(ProviderScope), findsOneWidget);
  });
  testWidgets('CupertinoBottomNavBar is present', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(CupertinoBottomNavBar), findsOneWidget);
  });

  test('GetIt instance is properly configured', () {
    expect(getIt.isRegistered<ApiService>(), isTrue);
    // Add more expectations for other registered dependencies
  });

  testWidgets('MyApp has correct theme', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    final CupertinoApp app =
        tester.widget<CupertinoApp>(find.byType(CupertinoApp));
    expect(app.theme!.primaryColor, CupertinoColors.systemGrey);
  });

  tearDownAll(() async {
    await Hive.close();
  });
}
