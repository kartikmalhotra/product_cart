/// TODO: Firebase

// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:bwys/config/application.dart';
// import 'package:bwys/modules/modem_watch_list/screens/modem_watch_list_search_screen.dart';
// import 'package:bwys/modules/work_orders/detail/screens/work_order_detail_screen.dart';
// import 'package:bwys/shared/models/notification_model.dart';
// import 'package:bwys/shared/models/pnm_common_model.dart';
// import 'package:bwys/shared/models/rest_api_error_model.dart';
// import 'package:bwys/utils/services/log_service.dart';

// class FirebaseMessagingService {
//   /// Instance of [FirebaseMessagingService]
//   static FirebaseMessagingService _instance;

//   /// Instance of [FirebaseMessaging]
//   static FirebaseMessaging _firebaseMessagingInstance;

//   /// Instance of [FlutterLocalNotificationsPlugin]
//   static FlutterLocalNotificationsPlugin _flutterLocalNotificationsInstance;

//   ///Notification id of last notification received when app is in running or
//   ///background state
//   ///Required this variable to stop twice redirection when notification is
//   ///tapped
//   String previousNotificationId;

//   FirebaseMessagingService._internal();

//   /// Return the instance of [FirebaseMessagingService]
//   static FirebaseMessagingService getInstance() {
//     if (_instance == null) {
//       _instance = FirebaseMessagingService._internal();
//     }
//     if (_firebaseMessagingInstance == null) {
//       _firebaseMessagingInstance = FirebaseMessaging();
//     }
//     if (_flutterLocalNotificationsInstance == null) {
//       _flutterLocalNotificationsInstance = FlutterLocalNotificationsPlugin();
//     }

//     return _instance;
//   }

//   FirebaseMessaging get firebaseMessagingInstance => _firebaseMessagingInstance;

//   FlutterLocalNotificationsPlugin get flutterLocalNotificationsInstance =>
//       _flutterLocalNotificationsInstance;

//   /// setup for fcm and local push notifications
//   void setupNotifications() async {
//     /// Ask for notification permission
//     if (Application.platform == TargetPlatform.iOS &&
//         !(await _firebaseMessagingInstance.requestNotificationPermissions())) {
//       return null;
//     }

//     setupLocalPushNotifications();

//     setupFcm();

//     /// register call back for fcm device token refresh, due to bug in official
//     /// firebase_messaging plugin this method is called every time the app starts
//     /// irrespective of token is refreshed or not, to neglect false calls we have
//     /// to store device token which was sent to server when user logs in local
//     /// storage and check it with this callback's token
//     _firebaseMessagingInstance.onTokenRefresh.listen((String newToken) {
//       /// if tokens don't match token has refreshed
//       if (newToken != Application.storageService.fcmDeviceToken) {
//         /// send token to server if user is logged in and session has not expired
//         if (PNMUser.isUserLoggedIn) {
//           _sendFCMTokenToRemote(newToken);
//         }
//       }
//     });
//   }

//   Future<void> setupFcm() async {
//     /// If user is already logged in and FCM Device token is not generated
//     if (PNMUser.isUserLoggedIn &&
//         Application.storageService.fcmDeviceToken == null) {
//       String token = await _firebaseMessagingInstance.getToken();
//       _sendFCMTokenToRemote(token);
//     }

//     /// Configure firebase messaging
//     /// we override only to callbacks onMessage{called when app is in foreground}
//     /// and onBackgroundMessage{called when app is in background or closed},
//     /// we are not override onLaunch and onResume callbacks as they won't get
//     /// triggered because we are using only data message notifications
//     _firebaseMessagingInstance.configure(
//       onLaunch: (Map<String, dynamic> message) async {
//         Application.logService.log(
//             "------------------Notification: onLaunch:------------------: $message");
//         onNotificationTapped(NotificationData.fromJson(
//           Application.platform == TargetPlatform.android
//               ? jsonDecode(jsonEncode(message["data"]))
//               : message,
//         ));
//       },
//       onResume: (Map<String, dynamic> message) async {
//         Application.logService.log(
//             "------------------Notification: onResume:------------------: $message");
//         onNotificationTapped(NotificationData.fromJson(
//           Application.platform == TargetPlatform.android
//               ? jsonDecode(jsonEncode(message["data"]))
//               : message,
//         ));
//       },
//       onMessage: (Map<String, dynamic> message) async {
//         Application.logService.log(
//             "------------------Notification: onMessage:------------------: $message");
//         fcmBackgroundMessageHandler(message);
//       },
//       onBackgroundMessage: Application.platform == TargetPlatform.android
//           ? fcmBackgroundMessageHandler
//           : null,
//     );
//   }

//   void setupLocalPushNotifications() {
//     /// custom icon for push notification in Android with transparent background
//     var initializationSettingsAndroid =
//         const AndroidInitializationSettings('ic_push_notification');

//     /// Initialise iOS to support and display a dialog to user when notifications
//     /// are displayed when app is in foreground iOS 9 and below versions
//     var initializationSettingsIOS = const IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);

//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//     _flutterLocalNotificationsInstance.initialize(
//       initializationSettings,
//       onSelectNotification: (String payload) async {
//         onNotificationTapped(NotificationData.fromJson(
//             Application.platform == TargetPlatform.android
//                 ? jsonDecode(payload)["data"]
//                 : jsonDecode(payload)));
//       },
//     );
//   }

//   /// Callback for notification tap
//   Future<String> onNotificationTapped(NotificationData notificationData) async {
//     Application.logService.log(
//         "------------------Notification: onSelectNotification------------------: $notificationData");

//     /// navigatorKey is not null then we can open desired screen
//     /// else payload is saved and will be accessed from [ApplicationTabs] screen,
//     /// navigatorKey is null in case app was in closed state when notification was
//     /// tapped
//     if (Application?.navigatorKey?.currentState != null) {
//       handleReDirections(notificationData);
//     } else {
//       Application.tappedNotificationData = notificationData;
//     }
//     return "";
//   }

//   void handleReDirections(NotificationData notificationData) {
//     Application.logService.log(
//         "------------------Notification: handleReDirections------------------");
//     if (notificationData != null) {
//       /// Check if notification id is for same notification then return
//       if (previousNotificationId == notificationData.id) {
//         return;
//       }

//       /// Store the new notification id into the [previousNotificationId]
//       previousNotificationId = notificationData.id;

//       switch (notificationData.payload.appDestination) {

//         /// 1 - Work Order Detail
//         case "1":
//           Application.navigatorKey.currentState.push(MaterialPageRoute(
//             builder: (context) => WorkOrderDetail(
//               id: int.tryParse(notificationData.payload.woId),
//             ),
//           ));
//           break;

//         /// 2 - Modem Watch List
//         case "2":
//           Application.navigatorKey.currentState.push(MaterialPageRoute(
//             builder: (context) => ModemWatchListSearchScreen(),
//           ));
//           break;
//       }

//       _markNotificationAsRead(notificationData);
//     }
//   }

//   /// To send FCM device token on remote
//   Future<void> _sendFCMTokenToRemote(String token) async {
//     var response = await Application.userRepository.updateFcmDeviceToken(token);
//     if ((response is! RestAPIErrorModel) &&
//         (response is! RestAPIUnAuthenticationModel)) {
//       /// store new device token in storage
//       Application.storageService.fcmDeviceToken = token;
//     } else {
//       Application.logService
//           .log("Can't send FCM token :: $response", type: Log.ERROR);
//     }
//   }

//   /// Invalidates current active token
//   void deleteActiveFCMToken() {
//     Application.storageService.fcmDeviceToken = null;
//     _firebaseMessagingInstance.deleteInstanceID();
//   }
// }

// /// handle all notifications received from fcm
// Future<dynamic> fcmBackgroundMessageHandler(
//     Map<String, dynamic> message) async {
//   Application.logService.log(
//       "------------------Notification: fcmBackgroundMessageHandler------------------: $message");

//   Map<String, dynamic> _message = Application.platform == TargetPlatform.android
//       ? Map<String, dynamic>.from(message["data"])
//       : message;

//   /// initialize android platform channel
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'channel_default',
//     'All Notifications',
//     'All the notifications for this applications are received in this channel.',
//     color: Colors.blue.shade800,
//     importance: Importance.max,
//     priority: Priority.defaultPriority,
//   );

//   var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);

//   int notificationId = int.tryParse(_message["id"].toString()) ?? 0;
//   Application.logService.log('Notification Id - $notificationId');

//   /// fire local push notification
//   FirebaseMessagingService.getInstance().flutterLocalNotificationsInstance.show(
//         notificationId,
//         _message["title"],
//         _message["message"],
//         platformChannelSpecifics,
//         payload: jsonEncode(message),
//       );

//   /// Add new unread notification to notifications updates stream
//   Application.notificationUpdatesStreamController.add(NotificationUpdateData(
//     notificationId: notificationId,
//     isRead: false,
//   ));
// }

// /// Callback for local notifications fired when app is in foreground in iOS 9
// /// and below versions.
// Future onDidReceiveLocalNotification(
//     int id, String title, String body, String payload) async {
//   print(
//       "------------------Notification: onDidReceiveLocalNotification------------------: $payload");

//   NotificationData notificationData =
//       NotificationData.fromJson(jsonDecode(payload));
//   Application.notificationStreamController.add(notificationData);

//   /// Add new unread notification to notifications updates stream
//   Application.notificationUpdatesStreamController.add(NotificationUpdateData(
//     notificationId: int.tryParse(notificationData.id) ?? 0,
//     isRead: false,
//   ));
// }

// void _markNotificationAsRead(NotificationData notificationData) {
//   print(
//       "------------------Notification: _markNotificationAsRead------------------: ${notificationData.id}");
//   int notificationId = int.tryParse(notificationData.id) ?? -1;
//   if (notificationId != -1) {
//     /// Mark notification as read
//     Application.userRepository.markNotificationsAsRead(notificationId);

//     /// Add read notification to notifications updates stream
//     Application.notificationUpdatesStreamController.add(NotificationUpdateData(
//       notificationId: notificationId,
//       isRead: true,
//     ));
//   }
// }