abstract class StorageService {
  Future<String> saveImage(String sourcePath, String fileName);
  Future<void> deleteImage(String imagePath);
  Future<String> getImagesDirectory();
  Future<bool> imageExists(String imagePath);
}