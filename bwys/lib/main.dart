import 'package:bwys/bwys_app.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/config/routes/routes.dart';
import 'package:bwys/shared/repository/user_repository.dart';
import 'package:bwys/utils/services/firebase_service.dart';
import 'package:bwys/utils/services/local_storage_service.dart';
import 'package:bwys/utils/services/native_api_service.dart';
import 'package:bwys/utils/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'utils/services/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Application.firebaseService = await FirebaseServices.getInstance();
  Application.secureStorageService = SecureStorageService.getInstance();
  Application.storageService = await LocalStorageService?.getInstance();
  Application.userRepository = UserRepositoryImpl();
  Application.nativeAPIService =  NativeAPIService.getInstance();
   
  Application.isDeviceAuthAvailable =
      Application.storageService!.isDeviceAuthAvailable;

  /// Store application prefered theme in the Application class
  Application.preferedTheme = Application.storageService!.themeMode;

  /// Store application language in the Application class
  Application.preferedLanguage = Application.storageService!.selectedLanguage;

  AppUser.isUserLoggedIn = Application.storageService!.isUserLoggedIn;

  RouteSetting.getInstance();
  runApp(BwysApp());
}
