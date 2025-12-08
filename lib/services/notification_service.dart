import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        navKey.currentState?.pushNamed(
          "/details",
          arguments: "random",
        );
      },
    );
  }


  static Future<void> testNotification() async {
    print("Instant notification test fired");

    await notificationsPlugin.show(
      1001,
      "INSTANT TEST",
      "If this appears, notifications are working.",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel',
          'Instant Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> showDailyNotificationNow() async {
    await notificationsPlugin.show(
      2000,
      "Random Recipe of the Day",
      "Tap to discover today's delicious surprise!",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Daily Recipe',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    print("Real daily notification fired instantly!");
  }

}
