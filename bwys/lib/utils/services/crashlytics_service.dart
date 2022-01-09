// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart' show kDebugMode, FlutterError;
// import 'package:bwys/config/application.dart';
// import 'package:bwys/constants/api_path.dart';
// import 'package:bwys/constants/app_constants.dart';
// import 'package:bwys/utils/services/log_service.dart';

// class CrashlyticsService {
//   /// Instance of [CrashlyticsService]
//   static CrashlyticsService _instance;

//   /// Instance of [FirebaseCrashlytics]
//   static FirebaseCrashlytics _crashlyticsInstance;

//   CrashlyticsService._internal();

//   /// Return the instance of [CrashlyticsService]
//   static Future<CrashlyticsService> getInstance() async {
//     if (_instance == null) {
//       _instance = CrashlyticsService._internal();
//     }
//     if (_crashlyticsInstance == null) {
//       print("INFO: Firebase initializeApp()");
//       await Firebase.initializeApp();
//       _crashlyticsInstance = FirebaseCrashlytics.instance;
//     }
//     return _instance;
//   }

//   /// setup crashlytics
//   void setupCrashlytics() async {
//     if (kDebugMode) {
//       /// Force disable Crashlytics collection while doing every day development.
//       /// Temporarily toggle this to true if you want to test crash reporting in your app.
//       /// Change this value to true to test crashlytics, and add a to-do if you do so.
//       await _crashlyticsInstance.setCrashlyticsCollectionEnabled(false);
//     } else {
//       /// Handle Crashlytics enabled status when not in Debug,
//       /// e.g. allow your users to opt-in to crash reporting.
//       await _crashlyticsInstance.setCrashlyticsCollectionEnabled(true);

//       /// Pass all uncaught errors from the framework to Crashlytics.
//       FlutterError.onError = _crashlyticsInstance.recordFlutterError;
//     }
//   }

//   bool isCrashlyticsCollectionEnabled() =>
//       _crashlyticsInstance.isCrashlyticsCollectionEnabled;

//   /// use this method to add logs to crashlytics,
//   /// try to use this via [LogService].
//   void addLog(String message) {
//     _crashlyticsInstance.log(message);
//   }

//   /// set custom log keys to send specific values on crashlytics for debugging
//   void logCustomKeys(String key, dynamic value) {
//     _crashlyticsInstance.setCustomKey(key, value);
//   }

//   /// set user identifier for crashlytics
//   void setUserIdentifier(String userIdentifier) {
//     _crashlyticsInstance.setUserIdentifier(userIdentifier);
//   }

//   void addCrashlyticsCustomKeys() {
//     Application.crashlyticsService.setUserIdentifier(
//       "${Application.storageService.syncedAPIUrl}${PNMRestEndPoints.usersList}/${PNMUser.userId}",
//     );
//     Application.crashlyticsService.logCustomKeys(
//       CrashlyticsCustomLogKeys.userType,
//       PNMUser.userType,
//     );
//     Application.crashlyticsService.logCustomKeys(
//       CrashlyticsCustomLogKeys.webAppVersion,
//       Application.storageService.syncedWebAppVersion,
//     );
//     Application.crashlyticsService.logCustomKeys(
//       CrashlyticsCustomLogKeys.webAppBaseUrl,
//       Application.storageService.syncedWebUrl,
//     );
//     Application.crashlyticsService.logCustomKeys(
//       CrashlyticsCustomLogKeys.apiBaseUrl,
//       Application.storageService.syncedAPIUrl,
//     );
//   }

//   /// Use FirebaseCrashlytics to throw an error. Use this for
//   /// confirmation that errors are being correctly reported.
//   void induceCrash() {
//     _crashlyticsInstance.log("DEBUG : Crash done for testing crashlytics");
//     _crashlyticsInstance.crash();
//   }
// }
