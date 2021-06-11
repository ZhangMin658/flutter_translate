import 'package:scan_and_translate/common/database/base_database.dart';
import 'package:scan_and_translate/function/common/model/history_obj.dart';
import 'package:sqflite/sqlite_api.dart';

class TranslateHistoryDB extends BaseDB {
  static String _table = "TranslateHistory";

  static final TranslateHistoryDB _translateHistoryDB = TranslateHistoryDB();
  static TranslateHistoryDB get translateHistoryDB => _translateHistoryDB;

  TranslateHistoryDB() : super(_table);
  @override
  Future<void> createTable(Database db) async {
    final String query = "CREATE TABLE IF NOT EXISTS $_table "
        "("
        "id TEXT PRIMARY KEY,"
        "scan_lang_code TEXT,"
        "scan_text TEXT,"
        "description TEXT,"
        "translate_lang_code TEXT,"
        "translate_text TEXT,"
        "date_time TEXT"
        ")";
    return await db.execute(query);
  }

  Future<List<HistoryObj>> getAllItem() async {
    final db = await database;
    var res = await db.query("$_table");
    List<HistoryObj> list =
        res.isNotEmpty ? res.map((c) => HistoryObj.fromJson(c)).toList() : [];
    return list;
  }
}
