import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz show initializeTimeZones;

import 'firebase_options.dart';
import 'services/notification_service.dart';

import 'screens/home.dart';
import 'screens/details.dart';
import 'screens/favorites.dart';
import 'screens/meals.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔥 BACKGROUND FCM MESSAGE: ${message.notification?.title}");
}


Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;


  await messaging.requestPermission(
    alert: true,
    sound: true,
    badge: true,
  );


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 FOREGROUND FCM: ${message.notification?.title}");


    NotificationService.notificationsPlugin.show(
      9000,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'fcm_channel',
          'Firebase Messages',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  });


  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📬 FCM CLICKED: ${message.notification?.title}");
  });


  String? token = await messaging.getToken();
  print("🔑 FCM TOKEN: $token");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  await NotificationService.initialize();


  if (Platform.isAndroid) {
    await Permission.notification.request();
  }


  await setupFCM();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      title: 'Meal App',
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: "Meal App"),
        "/details": (context) => const RecipeDetailsScreen(),
        "/favorites": (context) => const FavoriteMealsScreen(),
        "/meals": (context) => const MealsByCategoryScreen(),
      },
    );
  }
}
