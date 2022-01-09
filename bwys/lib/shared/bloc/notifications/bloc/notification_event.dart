part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  /// Passing class fields in a list to the Equatable super class
  const NotificationEvent([List props = const []]) : super();
}

class CheckPendingNotificationTapEvent extends NotificationEvent {
  const CheckPendingNotificationTapEvent();

  @override
  List<Object> get props => [];
}

class SingleNotificationUpdateEvent extends NotificationEvent {
  final int? notificationId;
  final bool? isRead;

  const SingleNotificationUpdateEvent({
    this.notificationId,
    this.isRead,
  });

  @override
  List<Object?> get props => [notificationId, isRead];
}

/// if [unreadCount] is zero [unreadIds] won't be accessed and all existing ids
/// will be dropped
class UnreadNotificationsUpdateEvent extends NotificationEvent {
  final int unreadCount;
  final List<int?>? unreadIds;

  const UnreadNotificationsUpdateEvent({
    required this.unreadCount,
    this.unreadIds,
  });

  @override
  List<Object?> get props => [unreadCount, unreadIds];
}
