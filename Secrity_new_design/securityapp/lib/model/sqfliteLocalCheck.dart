import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SavedSecurity {
  Database database;

  // Init databsae
  void createSavedSecurity() async {
    var db = await openDatabase("paya.db");
    print("LOG : $db");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db.db');
    print("LOG : $path");
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE checksSaved (id INTEGER PRIMARY KEY AUTOINCREMENT, img TEXT, trafficType TEXT)");
    });
  }

  // Not use directly, only use in other methods
  Future getDatabase() async {
    var db = await openDatabase("paya.db");
    // print("LOG : $db");
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db.db');
    // print("LOG : $path");
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE checksSaved (id INTEGER PRIMARY KEY AUTOINCREMENT, img TEXT, trafficType TEXT)");
    });
    return database;
  }

  // Read From DataBase
  Future<List<Map>> readySavedSecurity() async {
    // For opening db
    Database db = await getDatabase();

    List<Map> myBasketList = await db.rawQuery("SELECT * FROM checksSaved");
    return myBasketList;
  }

  // Adding a user basket
  Future<bool> addSavedSecurity({String img, String trafficType}) async {
    Database db = await getDatabase();

    try {
      await db.transaction((txn) async {
        int idAdder = await txn.rawInsert(
            "insert into checksSaved values(null, '$img', '$trafficType');");
        // print("This is $idAdder");
      });
      return true;
    } catch (e) {
      print("ERROR LOG FROM SQFLIT INSERTION $e");
      return false;
    }
  }

  // Delete user product basket by product id
  Future<bool> delSavedSecurity({id}) async {
    Database db = await getDatabase();
    try {
      await db.rawDelete("DELETE FROM checksSaved WHERE id = $id");
      return true;
    } catch (e) {
      print("ERROR LOG SQFLIT Delete Security img $e");
      return false;
    }
  }

  // Del * from Saved Security
  Future<bool> delAllSavedSecurity() async {
    Database db = await getDatabase();
    try {
      await db.rawDelete("DELETE FROM checksSaved");
      return true;
    } catch (e) {
      print("ERROR LOG SQFLIT Delete checksSaved $e");
      return false;
    }
  }
}
