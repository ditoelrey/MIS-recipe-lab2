import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../models/recipe_model.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late Meal meal;
  Recipe? recipe;

  bool _isLoading = true;

  final ApiService _api = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is Meal){
      meal = args;
      _loadRecipeDetails(meal.mealId);
    }
    else if (args == "random"){
      _loadRandomMeal();
    }
  }

  void _loadRecipeDetails(String id) async {
    final details = await _api.loadMealDetails(id);

    setState(() {
      recipe = details;
      _isLoading = false;
    });
  }

  void _loadRandomMeal() async {
    final details = await _api.loadRandomMeal();

    setState(() {
      recipe = details;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),


            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),

            const SizedBox(height: 20),


            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(recipe!.img, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),


            Text(
              recipe!.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "${recipe!.category} • ${recipe!.area}",
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 30),


            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  for (int i = 0; i < recipe!.ingredients.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "• ${recipe!.ingredients[i]} — ${recipe!.measures[i]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),


                  const Text(
                    "Instructions",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    recipe!.instructions,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),


                  if (recipe!.videoLink != null &&
                      recipe!.videoLink!.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final url = Uri.parse(recipe!.videoLink!);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          "Watch on YouTube",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
