class AddItemRequest {
  String name;
  String category;
  String color;
  String style;
  String brand;
  String season;
  String imagePath;

  AddItemRequest({
    required this.name,
    required this.category,
    required this.color,
    required this.style,
    required this.brand,
    required this.season,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'color': color,
      'style': style,
      'brand': brand,
      'season': season,
      'imagePath': imagePath,
    };
  }
}
