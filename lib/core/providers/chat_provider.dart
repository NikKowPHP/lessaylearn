import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_it/get_it.dart';
import 'package:lessay_learn/services/i_chat_service.dart';

final chatServiceProvider = Provider<IChatService>((ref) {
  return GetIt.I.get<IChatService>(); // Or, if not using GetIt: ChatService();
});