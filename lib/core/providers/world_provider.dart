import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lessay_learn/features/world/services/world_service.dart';


import 'package:lessay_learn/services/local_storage_service.dart';
final communityServiceProvider = Provider<ICommunityService>((ref) {
  return CommunityService(LocalStorageService());
});