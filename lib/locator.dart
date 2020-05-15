import 'package:comet_events/core/services/auth.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  // lazy singletons (services)
  locator.registerLazySingleton(() => Auth());
  // factories (view models)
}
