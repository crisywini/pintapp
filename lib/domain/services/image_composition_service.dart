import '../models/item.dart';

abstract class ImageCompositionService {
  Future<String> createOutfitComposition(List<Item> items, String outfitName);
}