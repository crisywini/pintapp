import '../data/database/database_helper.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/local_image_composition_service.dart';
import '../data/repositories/local_item_repository.dart';
import '../data/repositories/local_outfit_repository.dart';
import '../domain/repositories/item_repository.dart';
import '../domain/repositories/outfit_repository.dart';
import '../domain/services/storage_service.dart';
import '../domain/services/image_composition_service.dart';
import 'local_item_service.dart';
import 'local_outfit_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  DatabaseHelper? _databaseHelper;
  StorageService? _storageService;
  ImageCompositionService? _imageCompositionService;
  ItemRepository? _itemRepository;
  OutfitRepository? _outfitRepository;
  LocalItemService? _itemService;
  LocalOutfitService? _outfitService;

  DatabaseHelper get databaseHelper {
    _databaseHelper ??= DatabaseHelper();
    return _databaseHelper!;
  }

  StorageService get storageService {
    _storageService ??= LocalStorageService();
    return _storageService!;
  }

  ImageCompositionService get imageCompositionService {
    _imageCompositionService ??= LocalImageCompositionService(storageService);
    return _imageCompositionService!;
  }

  ItemRepository get itemRepository {
    _itemRepository ??= LocalItemRepository(databaseHelper, storageService);
    return _itemRepository!;
  }

  OutfitRepository get outfitRepository {
    _outfitRepository ??= LocalOutfitRepository(
      databaseHelper,
      storageService,
      imageCompositionService,
    );
    return _outfitRepository!;
  }

  LocalItemService get itemService {
    _itemService ??= LocalItemService(itemRepository);
    return _itemService!;
  }

  LocalOutfitService get outfitService {
    _outfitService ??= LocalOutfitService(outfitRepository, itemRepository);
    return _outfitService!;
  }

  void reset() {
    _databaseHelper = null;
    _storageService = null;
    _imageCompositionService = null;
    _itemRepository = null;
    _outfitRepository = null;
    _itemService = null;
    _outfitService = null;
  }
}