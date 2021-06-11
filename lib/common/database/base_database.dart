import 'dart:io';
import '../model/base_model.dart';

import '../constant/database_constant.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAccess {
  //define _database variable
  static Database _database;
// only have a single app-wide reference to the database
  static Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    // lazily instantiate the db the first time it is accessed
    _database = await initDB();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  static Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentsDirectory.path, DataBaseConstrants.DATA_BASE_NAME + ".db");
    Database database = await openDatabase(path,
        version: DataBaseConstrants.DATA_BASE_VERSION,
        onOpen: (database) {},
        onCreate: (Database database, int version) {});
    return database;
  }

  ///Close database when not use
  Future<void> closeDatabase() async {
    if (_database != null) return await _database.close();
  }
}

abstract class BaseDB {
  final String _table;
  Database _database;
  //constructor
  BaseDB(this._table);

  // only have a single app-wide reference to the database
  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    // lazily instantiate the db the first time it is accessed
    _database = await DBAccess.database;
    await createTable(_database);
    return _database;
  }

  //Need to overrite
  // SQL code to create the database table
  Future<void> createTable(Database db);

  //CRUD
  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.

  Future<int> insertByQuery(String queryString) async {
    Database db = await this.database;
    var res = await db.rawInsert(queryString);
    return res;
  }

  Future<int> insertByObject(BaseModel model) async {
    Database db = await this.database;
    var res = await db.insert("$_table", model.toJson());
    return res;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await this.database;
    return await db.query(_table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await this.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_table'));
  }

  //Get a row by column
  Future<List<Map<String, dynamic>>> getItemBy(
      dynamic searchValue, String searchColumn) async {
    Database db = await this.database;
    return await db
        .query("$_table", where: '$searchColumn = ?', whereArgs: [searchValue]);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateRow(BaseModel model, String columnId) async {
    Database db = await this.database;
    dynamic id = model.toJson()[columnId];
    return await db.update(_table, model.toJson(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateRowByJoin(BaseModel model, String columnId) async {
    //Database db = await this.database;
    var resultUpdate;
    resultUpdate = await updateRow(model, columnId);
    if (resultUpdate == 0) {
      resultUpdate = await insertByObject(model);
    }
    return resultUpdate;
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(dynamic id, String columnId) async {
    Database db = await this.database;
    return await db.delete(_table, where: '$columnId = ?', whereArgs: [id]);
  }

  ///Delete all row in database
  ///returned. result of delete task

  Future<int> deleteAll() async {
    final db = await this.database;
    return await db.rawDelete('DELETE FROM $_table');
  }
}
