import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/shared/bloc/notifications/repository/notification_repository.dart';
import 'package:bwys/shared/models/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

/// bloc for handling notification related tasks
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationsRepository repository;

  NotificationBloc({required this.repository})
      : super(const NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is CheckPendingNotificationTapEvent) {
      yield* _mapCheckPendingNotificationTapEventToState(event);
    } else if (event is SingleNotificationUpdateEvent) {
      yield* _mapSingleNotificationUpdateEventToState(event);
    } else if (event is UnreadNotificationsUpdateEvent) {
      yield* _mapUnreadNotificationsUpdateEventToState(event);
    }
  }

  /// check for saved notifications data/payload and fire state handle desired
  /// redirection
  Stream<NotificationState> _mapCheckPendingNotificationTapEventToState(
      CheckPendingNotificationTapEvent event) async* {
    NotificationData? tappedNotificationData =
        Application.tappedNotificationData;
    if (tappedNotificationData != null) {
      yield ProcessNotificationState(notificationData: tappedNotificationData);
      Application.tappedNotificationData = null;

      int notificationId = int.tryParse(tappedNotificationData.id!) ?? -1;
      if (notificationId != -1) {
        /// Mark notification as read
        Application.userRepository!.markNotificationsAsRead(notificationId);

        /// add new event that will decrement notification count if negative
        /// value is passed in [IncrementNotificationCountEvent] event
        add(SingleNotificationUpdateEvent(
            notificationId: notificationId, isRead: true));
      }
    }
  }

  Stream<NotificationState> _mapSingleNotificationUpdateEventToState(
      SingleNotificationUpdateEvent event) async* {
    print(
        "old unReadCount in Repository - ${repository.unReadNotifications.length}");

    /// if notification was unread
    if (!event.isRead!) {
      /// add unique notification id as key in unreadNotifications [HashMap]
      repository.unReadNotifications
          .putIfAbsent(event.notificationId, () => null);
    } else {
      /// remove unique notification id from unreadNotifications [HashMap]
      repository.unReadNotifications.remove(event.notificationId);
    }

    int newUnReadCount = repository.unReadNotifications.length;

    print("new unReadCount in Repository - $newUnReadCount");

    yield CountUpdatedState(unReadCount: newUnReadCount);
  }

  Stream<NotificationState> _mapUnreadNotificationsUpdateEventToState(
      UnreadNotificationsUpdateEvent event) async* {
    HashMap<int?, void> unReadNotificationsMap = HashMap();

    if (event.unreadCount != 0) {
      for (final int? unreadNotificationId in event.unreadIds!) {
        unReadNotificationsMap.putIfAbsent(
          unreadNotificationId,
          () => null,
        );
      }
    }

    repository.unReadNotificationsData = unReadNotificationsMap;

    yield CountUpdatedState(unReadCount: event.unreadCount);
  }
}
