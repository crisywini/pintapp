import '../models/outfit.dart';

abstract class OutfitRepository {
  Future<List<Outfit>> getAllOutfits();
  Future<Outfit> saveOutfit(Outfit outfit);
  Future<void> deleteOutfit(String id);
  Future<Outfit?> getOutfitById(String id);
}