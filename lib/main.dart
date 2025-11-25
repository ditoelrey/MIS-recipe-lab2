import 'package:flutter/material.dart';
import 'package:meal_app_lab2/screens/details.dart';
import 'package:meal_app_lab2/screens/meals.dart';
import 'screens/home.dart';
import 'screens/meals.dart';
import 'screens/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),

      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: "Meal Categories"),
        "/meals": (context) => const MealsByCategoryScreen(),
        "/details": (context) => const RecipeDetailsScreen(),
      },
    );
  }
}
