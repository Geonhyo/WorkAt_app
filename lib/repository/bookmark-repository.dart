import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workcafe/models/bookmark-info.dart';

class BookmarkRepository {
  late Database _database;
  final dbName = 'bookmarks';

  Future<Database?> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), '$dbName.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''CREATE TABLE $dbName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cafe_id TEXT, 
          cafe_name TEXT
          )''');
        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  Future<bool> checkDB(String cafeId) async{
    final Database? db = await database;

    List<Map<String, dynamic>> data = await db!.query(
      dbName,
      where: "cafe_id = ?",
      whereArgs: [cafeId],
    );

    if(data.isNotEmpty ) {
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> createBookmarkInfo(BookmarkInfo bookmarkInfo) async {
    final Database? db = await database;

    await db!.insert(
      dbName,
      bookmarkInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BookmarkInfo>> readBookmarkList() async {
    final Database? db = await database;

    final List<Map<String, dynamic>> maps = await db!.query(dbName);

    return List.generate(maps.length, (i) {
      return BookmarkInfo(
        cafeId: maps[i]['cafe_id'],
        cafeName: maps[i]['cafe_name'],
      );
    });
  }

  Future<void> updateBookmarkInfo(BookmarkInfo bookmarkInfo) async {
    final db = await database;

    await db!.update(
      dbName,
      bookmarkInfo.toMap(),
      where: "cafe_id = ?",
      whereArgs: [bookmarkInfo.cafeId],
    );
  }

  Future<void> deleteBookmarkInfo(String cafeId) async {
    final db = await database;

    await db!.delete(
      dbName,
      where: "cafe_id = ?",
      whereArgs: [cafeId],
    );
  }
}