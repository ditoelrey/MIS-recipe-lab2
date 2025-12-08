import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../widgets/meal_grid.dart';

class FavoriteMealsScreen extends StatefulWidget {
  const FavoriteMealsScreen({super.key});

  @override
  State<FavoriteMealsScreen> createState() => _FavoriteMealsScreenState();
}

class _FavoriteMealsScreenState extends State<FavoriteMealsScreen> {
  late List<Meal> _favorites;
  List<Meal> _filteredFavorites = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


    _favorites = ModalRoute.of(context)!.settings.arguments as List<Meal>;
    _filteredFavorites = List.from(_favorites);
  }


  void _filterMeals(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFavorites = List.from(_favorites);
      } else {
        _filteredFavorites = _favorites
            .where((meal) =>
            meal.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }


  void toggleFavorite(Meal meal) {
    setState(() {
      if (_favorites.contains(meal)) {
        _favorites.remove(meal);
      } else {
        _favorites.add(meal);
      }


      _filterMeals(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Favorite Meals",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange.shade400,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search favorites...",
                prefixIcon:
                Icon(Icons.search, color: Colors.orange.shade300),
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
            child: _filteredFavorites.isEmpty
                ? const Center(
              child: Text(
                "No favorite meals yet!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : MealGrid(
              meals: _filteredFavorites,
              favorites: _favorites,
              onFavoriteToggle: toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
