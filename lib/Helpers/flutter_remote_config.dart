// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/material.dart';
//
// class FirebaseRemoteConfigService {
//   final _remoteConfig = FirebaseRemoteConfig.instance;
//
//   Future<void> _setConfigSettings() async {
//     await _remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(minutes: 1),
//       minimumFetchInterval: const Duration(hours: 1),
//     ));
//   }
//
//   String getString(String key) => _remoteConfig.getString(key);
//
//   Future<void> _setDefaults() async => _remoteConfig.setDefaults(
//     const {
//       FirebaseRemoteConfigKeys.welcomeMessage: 'Hey there, this message is coming from local defaults.',
//     },
//   );
//
//   Future<void> fetchAndActivate() async {
//     bool updated = await _remoteConfig.fetchAndActivate();
//
//     if (updated) {
//       debugPrint('The config has been updated.');
//     } else {
//       debugPrint('The config is not updated..');
//     }
//   }
//
//   Future<void> initialize() async {
//     await _setConfigSettings();
//     await _setDefaults();
//     await fetchAndActivate();
//   }
//
// }
//
// class FirebaseRemoteConfigKeys {
//   static const String welcomeMessage = 'welcome_message';
//   static const String test = 'test';
// }