import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/emergency.dart';

import '../../../data/services/remote_config_service.dart';

final selectedEmergencyProvider = StateProvider<Emergency?>((ref) {
  final emergencies = ref.read(remoteConfigServiceProvider).appEmergencies;

  return emergencies.firstOrNull;
});

final getByTypeEmergencyProvider = Provider.family<Emergency?, String>((ref, type) {
  try {
    final emergencies = ref.read(remoteConfigServiceProvider).appEmergencies;

    return emergencies.firstWhere((element) => element.type == type);
  } catch (e) {}
  return null;
});
