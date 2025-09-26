import 'item.dart';

class Outfit {
  final String id;
  final String name;
  final String category;
  final List<Item> items;
  final String? compositeImagePath;
  final DateTime createdAt;

  Outfit({
    required this.id,
    required this.name,
    required this.category,
    required this.items,
    required this.createdAt,
    this.compositeImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'items': items.map((item) => item.toJson()).toList(),
      'compositeImagePath': compositeImagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      compositeImagePath: json['compositeImagePath'],
    );
  }
}