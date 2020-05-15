import 'package:comet_events/core/services/services.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  // lazy singletons (services) here
  locator.registerLazySingleton(() => AuthService());
}
