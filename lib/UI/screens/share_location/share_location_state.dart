import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/services/remote_config_service.dart';

final selectedEmergencyProvider = StateProvider<String>((ref) {
  final emergencies = ref.read(remoteConfigServiceProvider).appEmergencies;

  return emergencies.firstOrNull?.type ?? "";
});
