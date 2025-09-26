class Item {
  final String id;
  final String name;
  final String category;
  final String? color;
  final String? style;
  final String? brand;
  final String? season;
  final String imagePath;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.createdAt,
    this.color,
    this.style,
    this.brand,
    this.season,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'color': color,
      'style': style,
      'brand': brand,
      'season': season,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      imagePath: json['imagePath'],
      createdAt: DateTime.parse(json['createdAt']),
      color: json['color'],
      style: json['style'],
      brand: json['brand'],
      season: json['season'],
    );
  }
}