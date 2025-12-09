import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../widgets/category_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Category> _categories;
  List<Category> _filteredCategories = [];
  List<Meal> favoriteMeals = [];
  bool _isLoading = true;

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();


    FirebaseMessaging.instance.getToken().then((token) {
      print("🔑 FCM TOKEN: $token");
    });


    FirebaseMessaging.onMessage.listen((message) {
      print("📩 FOREGROUND PUSH:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 USER TAPPED NOTIFICATION!");
      Navigator.pushNamed(context, "/details", arguments: "random");
    });

    _loadCategories();


  }

  void _loadCategories() async {
    final list = await _apiService.loadCategories();
    setState(() {
      _categories = list;
      _filteredCategories = list;
      _isLoading = false;
    });
  }

  void _filterCategory(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void navigateToMeals(Category category) {
    Navigator.pushNamed(
      context,
      "/meals",
      arguments: {
        "category": category,
        "favorites": favoriteMeals,
        "updateFavorites": (Meal meal) {
          setState(() {
            if (favoriteMeals.contains(meal)) {
              favoriteMeals.remove(meal);
            } else {
              favoriteMeals.add(meal);
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange.shade400,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/details",
                arguments: "random",
              );
            },
            icon: Icon(Icons.dinner_dining, color: Colors.white, size: 32),
            padding: const EdgeInsets.only(right: 16.0)
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search category...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                ),
                prefixIcon:
                Icon(Icons.search, color: Colors.orange.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.orange.shade200,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.orange.shade600,
                    width: 2,
                  ),
                ),
              ),
              onChanged: _filterCategory,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CategoryGrid(
                categories: _filteredCategories,
                onCategoryTap: navigateToMeals,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/favorites",
            arguments: favoriteMeals,
          );
        },
        backgroundColor: Colors.orange.shade400,
        child: const Icon(Icons.favorite, color: Colors.white),

      ),

    );
  }
}
