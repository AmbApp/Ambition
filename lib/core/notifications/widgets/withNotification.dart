import 'dart:developer';

import 'package:ambition_app/Utils/constants.dart';
import 'package:ambition_app/Utils/helpers.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../ride/screens/map_screen.dart';

import '../services/notifications_model.dart';
import '../services/notification_service.dart';

Map<String, Function(BuildContext, dynamic)> notificationsConfig = {
  'RIDE_REQUEST': (BuildContext context, dynamic notification) {
    logger(notification);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapScreen(
                notification: notification,
                mapMode: MapMode.driver,
              )),
    );

    // showModalBottomSheet(
    //   context: context,
    //   isDismissible: false,
    //   builder: (context) => DriverRideNotificationModal(notification: notification),
    // );
  },
  'RIDE_ACCEPTED': (BuildContext context, dynamic notification) {
    logger('in RIDE_ACCEPTED');

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapScreen(mapMode: MapMode.passenger)),
    );

    // final MapViewModel viewModel =
    //     Provider.of<MapViewModel>(context, listen: false);
    // // set the cron job to update passenger location
    // viewModel.hasDriverAcceptedPassengerRideRequest = true;
    // // viewModel.rideId = notification.rideId!;
    // viewModel.updatePassengerLoc();
    // // viewModel.getRideLocation(notification.rideId!);
    // viewModel.cronUpdatePassengerLoc();
    // viewModel.cronGetRideLoc();
  },
};

class WithNotifications extends StatefulWidget {
  final Widget child;

  const WithNotifications({required Key key, required this.child})
      : super(key: key);

  @override
  WithNotificationsState createState() => WithNotificationsState();
}

class WithNotificationsState extends State<WithNotifications> {
  late NotificationsModel notificationsModel;
  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      notificationsModel =
          Provider.of<NotificationsModel>(context, listen: false);

      NotificationService notificationService = NotificationService(
        onNotificationReceived: (dynamic notification, String type) {
          logger('notification type: ${type}');
          logger('notification: ${notification} DONE');

          notificationsConfig[type]!(context, notification);

          notificationsModel.addNotification(notification);
        },
      );
      notificationService.registerNotification();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
