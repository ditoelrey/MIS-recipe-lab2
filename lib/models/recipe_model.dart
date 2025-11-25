class Recipe {
  String mealId;
  String name;
  String img;
  String category;
  String area;
  String instructions;
  String? videoLink;
  List<String> ingredients;
  List<String> measures;

  Recipe({
    required this.mealId,
    required this.name,
    required this.img,
    required this.category,
    required this.area,
    required this.instructions,
    required this.videoLink,
    required this.ingredients,
    required this.measures,
  });

  Recipe.fromJson(Map<String, dynamic> data)
      : mealId = data['idMeal'],
        name = data['strMeal'][0].toUpperCase() +
            data['strMeal'].substring(1),
        img = data['strMealThumb'],
        category = data['strCategory'] ?? '',
        area = data['strArea'] ?? '',
        instructions = data['strInstructions'] ?? '',
        videoLink = data['strYoutube'],
        ingredients = [],
        measures = [] {
   
    for (int i = 1; i <= 20; i++) {
      final ingredient = data['strIngredient$i'];
      final measure = data['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }
  }

  Map<String, dynamic> toJson() => {
    'mealId': mealId,
    'name': name,
    'img': img,
    'category': category,
    'area': area,
    'instructions': instructions,
    'videoLink': videoLink,
    'ingredients': ingredients,
    'measures': measures,
  };
}
