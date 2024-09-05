import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/app.dart';
import 'package:lessay_learn/features/chat/widgets/chat_list.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';
import 'package:lessay_learn/core/widgets/cupertino_bottom_nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/chat/widgets/chat_list.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider =
    Provider<ChatService>((ref) => ChatService(LocalStorageService()));

class MockChatService extends Mock implements ChatService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  PathProviderPlatform.instance = MockPathProviderPlatform();

  await Hive.initFlutter();
  group('Widget Tests', () {
    testWidgets('MyApp widget test', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      expect(find.byType(CupertinoApp), findsOneWidget);
      expect(find.byType(CupertinoBottomNavBar), findsOneWidget);
    });

    testWidgets('HomeScreen widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: CupertinoApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester
          .pump(Duration(seconds: 2)); // Allow time for async operations

      expect(find.byType(CupertinoPageScaffold), findsOneWidget);
      expect(find.byType(CupertinoNavigationBar), findsOneWidget);
      expect(find.text('Chats'), findsOneWidget);
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
      expect(find.byType(ChatList), findsOneWidget);
    });
  });

  group('ChatList Widget Tests', () {
    late MockChatService mockChatService;

    setUp(() {
      mockChatService = MockChatService();
    });

    testWidgets(
        'ChatList displays loading indicator when future is not resolved',
        (WidgetTester tester) async {
      when(() => mockChatService.getChats()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatServiceProvider.overrideWithValue(mockChatService),
          ],
          child: CupertinoApp(home: ChatList()),
        ),
      );

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });


  });
}
