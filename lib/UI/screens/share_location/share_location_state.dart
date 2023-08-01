import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/emergency.dart';

import '../../../data/services/remote_config_service.dart';

final selectedEmergencyProvider = StateProvider<Emergency?>((ref) {
  final emergencies = ref.read(remoteConfigServiceProvider).appEmergencies;

  return emergencies.firstOrNull;
});
