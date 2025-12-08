import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid.dart';
import '../services/notification_service.dart';

class MealsByCategoryScreen extends StatefulWidget {
  const MealsByCategoryScreen({super.key});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  late Category category;
  late List<Meal> favorites;
  late Function(Meal) updateFavorites;

  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];

  bool _isLoading = true;

  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    category = args["category"] as Category;
    favorites = args["favorites"] as List<Meal>;
    updateFavorites = args["updateFavorites"] as Function(Meal);

    _loadMeals();
  }

  void _loadMeals() async {
    final list = await _api.loadMealsByCategory(category.name);

    setState(() {
      _meals = list;
      _filteredMeals = list;
      _isLoading = false;
    });
  }

  void _filterMeals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMeals = _meals;
      } else {
        _filteredMeals = _meals
            .where((meal) =>
            meal.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void toggleFavorite(Meal meal) {
    setState(() {
      updateFavorites(meal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(
          category.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange.shade400,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search meals...",
                prefixIcon: Icon(Icons.search, color: Colors.orange.shade300),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: Colors.orange.shade200, width: 1.5),
                ),
              ),
              onChanged: _filterMeals,
            ),
          ),

          Expanded(
            child: MealGrid(
              meals: _filteredMeals,
              favorites: favorites,
              onFavoriteToggle: toggleFavorite,
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/favorites",
            arguments: favorites,
          );
        },
        backgroundColor: Colors.orange.shade400,
        child: const Icon(Icons.favorite, color: Colors.white),
      ),
    );
  }
}
