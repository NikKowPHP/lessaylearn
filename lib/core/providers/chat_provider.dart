import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';

import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

// Changed to provide IChatService
final chatServiceProvider = Provider<IChatService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return ChatService(localStorageService);
});