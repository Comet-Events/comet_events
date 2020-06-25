import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfig remoteConfig;

  Future<RemoteConfig> fetch() async {
    if(remoteConfig == null) {
      remoteConfig = await RemoteConfig.instance;
      // Enable developer mode to relax fetch throttling
      // remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
      // remoteConfig.setDefaults(<String, dynamic>{
      //   'welcome': 'default welcome',
      //   'hello': 'default hello',
      // });
      await _refresh();
      return remoteConfig;
    } else {
      await _refresh();
      return remoteConfig;
    }
  }

  Future<void> _refresh() async {
    if(remoteConfig != null) {
      await remoteConfig.fetch(expiration: const Duration(seconds: 5));
      await remoteConfig.activateFetched();
    } else print('Remote Config not initialized!');
  }
}