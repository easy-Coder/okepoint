import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/configs/app_config.dart';

import '../models/emergency.dart';

final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  return RemoteConfigService(ref);
});

class RemoteConfigService {
  final Ref ref;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigService(this.ref) {
    _activateRemoteConfig(development: AppFlavorConfigs.instance.isDevelopment);
  }

  Future<bool> _activateRemoteConfig({bool development = true}) async {
    try {
      if (development) {
        await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 5),
        ));
      }
      return await _remoteConfig.fetchAndActivate();
    } catch (_) {}
    return false;
  }

  List<Emergency> get appEmergencies {
    try {
      final response = _remoteConfig.getValue("emergencies");
      final data = List<dynamic>.from(jsonDecode(response.asString()));
      return data.map((e) => Emergency.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
