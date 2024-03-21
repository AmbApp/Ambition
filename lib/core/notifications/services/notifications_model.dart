import 'package:flutter/material.dart';

class NotificationsModel extends ChangeNotifier {
  List<dynamic> _notifications = [];

  List<dynamic> get notifications => _notifications;

  set notifications(List<dynamic> notifications) {
    _notifications = notifications;
    notifyListeners();
  }

  void addNotification(dynamic notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void removeNotification(dynamic notification) {
    _notifications.remove(notification);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void updateNotification(dynamic notification) {
    int index = _notifications
        .indexWhere((element) => element.rideId == notification.rideId);
    _notifications[index] = notification;
    notifyListeners();
  }

  dynamic getLatestNotification(String type) {
    List<dynamic> notifications =
        _notifications.where((element) => element.type == type).toList();
    if (notifications.isNotEmpty) {
      return notifications[notifications.length - 1];
    }
    return null;
  }
}
