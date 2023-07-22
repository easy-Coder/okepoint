import '../app.dart';
import '../data/models/config.dart';

class AppFlavorConfigs {
  AppFlavorConfigs._();

  AppFlavor flavor = AppFlavor.dev;

  static AppFlavorConfigs? _intance;

  set setFlavor(AppFlavor value) => flavor = value;

  static AppFlavorConfigs get instance {
    _intance ??= AppFlavorConfigs._();
    return _intance!;
  }

  ConfigValues get config {
    if (flavor == AppFlavor.dev) return _devConfig;
    return _prodConfig;
  }

  ConfigValues get _devConfig => const ConfigValues();

  ConfigValues get _prodConfig => const ConfigValues();
}
