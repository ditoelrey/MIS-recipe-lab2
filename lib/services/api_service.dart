import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../models/recipe_model.dart';

class ApiService {

  Future<List<Category>> loadCategories() async {
    List<Category> categoryList = [];

    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List categoriesJson = data['categories'];

      for (var item in categoriesJson) {
        categoryList.add(Category.fromJson(item));
      }
    }

    return categoryList;
  }


  List<Category> searchCategoryByName(
      List<Category> all, String query) {

    if (query.isEmpty) return all;

    List<Category> filtered = [];

    for (var c in all) {
      if (c.name.toLowerCase().contains(query.toLowerCase())) {
        filtered.add(c);
      }
    }

    return filtered;
  }

  Future<List<Meal>> loadMealsByCategory(String category) async {
    List<Meal> mealList = [];

    final response = await http.get(
      Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'];

      for (var item in mealsJson) {
        mealList.add(Meal.fromJson(item));
      }
    }

    return mealList;
  }

  Future<List<Meal>> searchMealsInApi(String query) async {
    List<Meal> mealList = [];

    final response = await http.get(
      Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null) {
        final List mealsJson = data['meals'];

        for (var item in mealsJson) {
          mealList.add(Meal.fromJson(item));
        }
      }
    }

    return mealList;
  }


  Future<Recipe?> loadMealDetails(String id) async {
    final response = await http.get(
      Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null) {
        return Recipe.fromJson(data['meals'][0]);
      }
    }

    return null;
  }


  Future<Recipe?> loadRandomMeal() async {
    final response = await http.get(
      Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/random.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null) {
        return Recipe.fromJson(data['meals'][0]);
      }
    }

    return null;
  }
}
