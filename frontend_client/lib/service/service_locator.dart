import 'package:get_it/get_it.dart';

class ServiceLocator {
  static final GetIt _instance = GetIt.asNewInstance();

  const ServiceLocator._();

  static void register<T extends Object>(T value) {
    if (!_instance.isRegistered<T>()) {
      _instance.registerSingleton(value);
    }
  }

  static void registerService() {}

  static T get<T extends Object>() {
    assert(_instance.isRegistered<T>(), '$T is not registered');
    return _instance.get<T>();
  }
}
