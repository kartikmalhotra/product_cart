import 'package:bwys/constants/path/api_path.dart';
import 'package:flutter/material.dart';

enum RestAPIRequestMethods { GET, PUT, POST, DELETE, PATCH }

enum InputFieldError { Empty, Invalid, NOT_MATCH }

abstract class AppConstants {
  static const appName = "BWYS";
  static const List<String> _supportedLanguages = [
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'pt',
    'th'
  ];
  static const List<Locale> _supportedLocales = [
    Locale('en', ''),
    Locale('de', ''),
    Locale('es', ''),
    Locale('fr', ''),
    Locale('ja', ''),
    Locale('pt', ''),
    Locale('th', ''),
  ];

  static const List<String> _skipAuthAPIs = [
    AppRestEndPoints.login,
    AppRestEndPoints.forgotPassword,
    AppRestEndPoints.ldapStatus
  ];

 

 
  static const int _sizeForClusterPage = 10;
  static const int _uphistoricalPage = 20;
  static List<String> get supportedLanguages => _supportedLanguages;
  static List<Locale> get supportedLocales => _supportedLocales;
  static List<String> get skipAuthAPIs => _skipAuthAPIs;
  static int get sizeForClusterPage => _sizeForClusterPage;
  static int get uphistoricalPage => _uphistoricalPage;
}

abstract class AppSharedPreferencesKeys {
  static const String _themeMode = "THEME_MODE";
  static const String _selectedLanguage = "LANGUAGE_CODE";
  static const String _webAppUrl = "WEB_APP_BASE_URL";
  static const String _apiUrl = "API_BASE_URL";
  static const String _gisApiUrl = "GIS_API_BASE_URL";
  static const String _webAppVersion = "WEB_APP_VERSION";
  static const String _isUserLoggedIn = "IS_USER_LOGGED_IN";
  static const String _isDeviceAuthAvailable = "IS_DEVICE_AUTH_AVAILABLE";
  static const String _dismissedBroadcasts = "DISMISSED_BROADCASTS";
  static const String _recentSearches = "RECENT_SEARCHES";
  static const String _inProgressFixes = "INPROGRESS_TROUBLESHOOT";
  static const String _fcmDeviceToken = "FCM_DEVICE_TOKEN";
  static const String _isSpectraBarsAbsolute = "SPECTRA_CHANNEL_BARS";
  static const String _isAnalyzerDeleted = "DELETE_ANALYZER";

  static String get themeMode => _themeMode;
  static String get selectedLanguage => _selectedLanguage;
  static String get webAppUrl => _webAppUrl;
  static String get apiUrl => _apiUrl;
  static String get gisApiUrl => _gisApiUrl;
  static String get webAppVersion => _webAppVersion;
  static String get isUserLoggedIn => _isUserLoggedIn;
  static String get isDeviceAuthAvailable => _isDeviceAuthAvailable;
  static String get dismissedBroadcasts => _dismissedBroadcasts;
  static String get recentSearches => _recentSearches;
  static String get inProgressFixes => _inProgressFixes;
  static String get fcmDeviceToken => _fcmDeviceToken;
  static String get isSpectraBarsAbsolute => _isSpectraBarsAbsolute;
  static String get isAnalyzerDeleted => _isAnalyzerDeleted;
}

abstract class AppSecureStoragePreferencesKeys {
  static const String _username = "USERNAME";
  static const String _authToken = "AUTH_TOKEN";
  static const String _password = "USER_PASSWORD";

  static String get username => _username;
  static String get authToken => _authToken;
  static String get userPassword => _password;
}

abstract class CrashlyticsCustomLogKeys {
  static const String _userType = "USER_TYPE";
  static const String _webAppVersion = "WEB_APP_VERSION";
  static const String _webAppBaseUrl = "WEB_APP_BASE_URL";
  static const String _apiBaseUrl = "API_BASE_URL";
  static const String _deviceSize = "DEVICE_SIZE";

  static String get userType => _userType;
  static String get webAppVersion => _webAppVersion;
  static String get webAppBaseUrl => _webAppBaseUrl;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get deviceSize => _deviceSize;
}

/// This class contains the default color of map_pins_color / default colors of color preference feature
abstract class DefaultColorPreference {
  static Map<String, String?> _mapPinsColor = {
    "immediate_action_req": "#FF2D27",
    "high_monitoring_freq": "#DDC934",
    "no_action_req": "#00C600",
    "invalid": "#AFACAC",
    "offline": "#000000",
    "qam_4096": "#8CA26E",
    "qam_1024": "#D5CB6D",
    "qam_256": "#D1A872",
    "qam_less_256": "#96544D",
    "unused_channel": "#585858",
    "upstream_correlation": "#3285D8",
    "downstream_correlation": "#3285D8",
    "rxmer_correlation": "#3285D8",
    "cmts_pin": "#0B5382",
    "node_pin": "#0B5484"
  };

  /// Getters
  static Map<String, String?> get mapPinsColor => _mapPinsColor;

  /// Setters
  static set setDefaultColorValue(Map<String, String?> data) {
    _mapPinsColor = data;
  }
}
