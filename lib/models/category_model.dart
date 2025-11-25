class Category {
  String id;
  String name;
  String img;
  String description;

  Category({
    required this.id,
    required this.name,
    required this.img,
    required this.description,
  });

  Category.fromJson(Map<String, dynamic> data)
      : id = data['idCategory'],
        name = data['strCategory'][0].toUpperCase() +
            data['strCategory'].substring(1),
        img = data['strCategoryThumb'],
        description = data['strCategoryDescription'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'img': img,
    'description': description,
  };
}
