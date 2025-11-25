import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import 'meal_card.dart';

class MealGrid extends StatefulWidget {
  final List<Meal> meals;

  const MealGrid({super.key, required this.meals});

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
        return MealCard(meal: widget.meals[index]);
      },
    );
  }
}
