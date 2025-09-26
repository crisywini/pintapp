import '../models/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getAllItems();
  Future<List<Item>> getItemsByCategory(String category);
  Future<Item> saveItem(Item item);
  Future<void> deleteItem(String id);
  Future<Item?> getItemById(String id);
}