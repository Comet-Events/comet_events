import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  // lazy singletons (services) here
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => CometThemeManager());
  /// stacked services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DialogService());
}
