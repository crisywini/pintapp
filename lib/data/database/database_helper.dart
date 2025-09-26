import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/models/item.dart';
import '../../domain/models/outfit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pintapp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        color TEXT,
        style TEXT,
        brand TEXT,
        season TEXT,
        imagePath TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE outfits (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        compositeImagePath TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE outfit_items (
        outfitId TEXT NOT NULL,
        itemId TEXT NOT NULL,
        PRIMARY KEY (outfitId, itemId),
        FOREIGN KEY (outfitId) REFERENCES outfits (id),
        FOREIGN KEY (itemId) REFERENCES items (id)
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert('items', item.toJson());
  }

  Future<List<Item>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) => Item.fromJson(maps[i]));
  }

  Future<List<Item>> getItemsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Item.fromJson(maps[i]));
  }

  Future<Item?> getItemById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Item.fromJson(maps.first);
  }

  Future<int> deleteItem(String id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertOutfit(Outfit outfit) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('outfits', {
        'id': outfit.id,
        'name': outfit.name,
        'category': outfit.category,
        'compositeImagePath': outfit.compositeImagePath,
        'createdAt': outfit.createdAt.toIso8601String(),
      });

      for (final item in outfit.items) {
        await txn.insert('outfit_items', {
          'outfitId': outfit.id,
          'itemId': item.id,
        });
      }
    });
    return 1;
  }

  Future<List<Outfit>> getAllOutfits() async {
    final db = await database;
    final List<Map<String, dynamic>> outfitMaps = await db.query('outfits');

    List<Outfit> outfits = [];
    for (final outfitMap in outfitMaps) {
      final items = await _getOutfitItems(outfitMap['id']);
      outfits.add(Outfit(
        id: outfitMap['id'],
        name: outfitMap['name'],
        category: outfitMap['category'],
        items: items,
        compositeImagePath: outfitMap['compositeImagePath'],
        createdAt: DateTime.parse(outfitMap['createdAt']),
      ));
    }
    return outfits;
  }

  Future<List<Item>> _getOutfitItems(String outfitId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT i.* FROM items i
      JOIN outfit_items oi ON i.id = oi.itemId
      WHERE oi.outfitId = ?
    ''', [outfitId]);

    return List.generate(maps.length, (i) => Item.fromJson(maps[i]));
  }

  Future<Outfit?> getOutfitById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'outfits',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;

    final outfitMap = maps.first;
    final items = await _getOutfitItems(id);

    return Outfit(
      id: outfitMap['id'],
      name: outfitMap['name'],
      category: outfitMap['category'],
      items: items,
      compositeImagePath: outfitMap['compositeImagePath'],
      createdAt: DateTime.parse(outfitMap['createdAt']),
    );
  }

  Future<int> deleteOutfit(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('outfit_items', where: 'outfitId = ?', whereArgs: [id]);
      await txn.delete('outfits', where: 'id = ?', whereArgs: [id]);
    });
    return 1;
  }
}