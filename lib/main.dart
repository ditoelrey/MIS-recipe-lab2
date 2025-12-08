import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz show initializeTimeZones;

import 'firebase_options.dart';
import 'services/notification_service.dart';

import 'package:permission_handler/permission_handler.dart';

import 'screens/home.dart';
import 'screens/details.dart';
import 'screens/favorites.dart';
import 'screens/meals.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();

  if (Platform.isAndroid) {
    await Permission.notification.request();
  }

  await NotificationService.showDailyNotificationNow();

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
