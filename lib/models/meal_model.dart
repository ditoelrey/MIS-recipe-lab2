class Meal {
  String mealId;
  String name;
  String img;

  Meal({
    required this.mealId,
    required this.name,
    required this.img,
  });

  Meal.fromJson(Map<String, dynamic> data)
      : mealId = data['idMeal'],
        name = data['strMeal'][0].toUpperCase() +
            data['strMeal'].substring(1),
        img = data['strMealThumb'];

  Map<String, dynamic> toJson() => {
    'mealId': mealId,
    'name': name,
    'img': img,
  };
}
