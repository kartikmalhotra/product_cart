part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  final NotificationData? notificationData;

  const NotificationState({this.notificationData});
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();

  @override
  List<Object> get props => [];
}

class ProcessNotificationState extends NotificationState {
  final NotificationData notificationData;

  const ProcessNotificationState({required this.notificationData});

  @override
  List<Object> get props => [notificationData];
}

class CountUpdatedState extends NotificationState {
  final int unReadCount;

  const CountUpdatedState({required this.unReadCount});

  @override
  List<Object> get props => [unReadCount];
}
