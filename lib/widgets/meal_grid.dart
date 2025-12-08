import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import 'meal_card.dart';

class MealGrid extends StatefulWidget {
  final List<Meal> meals;
  final List<Meal> favorites;
  final Function(Meal) onFavoriteToggle;

  const MealGrid({
    super.key,
    required this.meals,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  State<MealGrid> createState() => _MealGridState();
}

class _MealGridState extends State<MealGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 200 / 244,
      ),
      itemCount: widget.meals.length,
      itemBuilder: (context, index) {
        final meal = widget.meals[index];
        final isFavorite = widget.favorites.contains(meal);

        return MealCard(
          meal: meal,
          isFavorite: isFavorite,
          onFavoriteToggle: () => widget.onFavoriteToggle(meal),
        );
      },
    );
  }
}
