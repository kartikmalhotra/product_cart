import 'dart:collection';

abstract class NotificationsRepository {
  /// Getters and Setters for list of unread notifications
  HashMap<int?, void> get unReadNotifications => HashMap();

  set unReadNotificationsData(HashMap<int?, void> data);
}

class NotificationsRepositoryImpl implements NotificationsRepository {
  HashMap<int?, void> _unReadNotificationsData = HashMap();

  /// Getter for list of unread notifications
  @override
  HashMap<int?, void> get unReadNotifications => _unReadNotificationsData;

  /// Setter for list of unread notifications
  @override
  set unReadNotificationsData(HashMap<int?, void> data) {
    _unReadNotificationsData = data;
  }
}
