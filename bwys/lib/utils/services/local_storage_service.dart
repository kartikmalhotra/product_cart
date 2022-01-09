import 'dart:convert';

import 'package:bwys/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._internal();

  static Future<LocalStorageService?> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService._internal();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  /// Theme Mode
  String? get themeMode => _getDataFromDisk(AppSharedPreferencesKeys.themeMode);
  set themeMode(String? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.themeMode, value);

  /// Selected Language
  String get selectedLanguage =>
      _getDataFromDisk(AppSharedPreferencesKeys.selectedLanguage) ?? 'en';
  set selectedLanguage(String? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.selectedLanguage, value);

  /// Synced Web App URL
  String? get syncedWebUrl =>
      _getDataFromDisk(AppSharedPreferencesKeys.webAppUrl) ?? null;
  set syncedWebUrl(String? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.webAppUrl, value);

  /// Synced API URL
  String? get syncedAPIUrl =>
      _getDataFromDisk(AppSharedPreferencesKeys.apiUrl) ?? null;
  set syncedAPIUrl(String? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.apiUrl, value);

  /// GIS API URL
  String? get gisAPIUrl =>
      _getDataFromDisk(AppSharedPreferencesKeys.gisApiUrl) ?? null;
  set gisAPIUrl(String? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.gisApiUrl, value);

  /// Synced Web App Version
  String? get syncedWebAppVersion =>
      _getDataFromDisk(AppSharedPreferencesKeys.webAppVersion) ?? null;
  set syncedWebAppVersion(String? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.webAppVersion, value);

  /// is user logged in flag
  bool get isUserLoggedIn =>
      _getDataFromDisk(AppSharedPreferencesKeys.isUserLoggedIn) ?? false;
  set isUserLoggedIn(bool value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.isUserLoggedIn, value);

  // is Device supports biometric authentication
  bool? get isDeviceAuthAvailable =>
      _getDataFromDisk(AppSharedPreferencesKeys.isDeviceAuthAvailable) ?? null;
  set isDeviceAuthAvailable(bool? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.isDeviceAuthAvailable, value);

  // Dismissed broadcasts
  Map<String, dynamic> get dismissedBroadcasts => jsonDecode(
      _getDataFromDisk(AppSharedPreferencesKeys.dismissedBroadcasts) ?? null);
  set dismissedBroadcasts(Map<String, dynamic> value) => _saveDataToDisk(
      AppSharedPreferencesKeys.dismissedBroadcasts, jsonEncode(value));

  // is analyzer deleted
  bool get isAnalyzerDeleted =>
      _getDataFromDisk(AppSharedPreferencesKeys.isAnalyzerDeleted) ?? true;
  set isAnalyzerDeleted(bool value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.isAnalyzerDeleted, value);

  /// List of in-progress troubleshooting data for correlation group or node
  dynamic _getDataFromDisk(String key) {
    var value = _preferences!.get(key);
    return value;
  }

  /// FCM Device Token
  String? get fcmDeviceToken =>
      _getDataFromDisk(AppSharedPreferencesKeys.fcmDeviceToken) ?? null;
  set fcmDeviceToken(String? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.fcmDeviceToken, value);

  /// Spectra Channel Toggle Switch
  bool get spectraChannelSwitch =>
      _getDataFromDisk(AppSharedPreferencesKeys.isSpectraBarsAbsolute) ?? true;
  set spectraChannelSwitch(bool? value) =>
      _saveDataToDisk(AppSharedPreferencesKeys.isSpectraBarsAbsolute, value);

  void _saveDataToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences!.setString(key, content);
    } else if (content is bool) {
      _preferences!.setBool(key, content);
    } else if (content is int) {
      _preferences!.setInt(key, content);
    } else if (content is double) {
      _preferences!.setDouble(key, content);
    } else if (content is List<String>) {
      _preferences!.setStringList(key, content);
    } else {
      _preferences!.setString(key, content.toString());
    }
  }
}
