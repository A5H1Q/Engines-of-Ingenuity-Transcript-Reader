import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:engine_reader/main.dart';

class DatabaseHelper {
  final String tableTodoList = "todoTable";
  final String columnId = "id";
  final String columnItemName = "itemName";
  final String columnDateCreated = "dateCreated";
  final String columnWww = "www";
  final String columnKind = "kind";
  final String columnJmp = "jmp";

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "todo_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableTodoList($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnDateCreated TEXT, $columnWww TEXT, $columnKind TEXT, $columnJmp INTEGER)");
    await db.execute(
        "INSERT INTO todoTable(id, itemName, dateCreated, www, kind, jmp) VALUES(0, 'gdyxtanzcoseq', 'started', 'https://www.uh.edu', 'tale', 1)");
  }

  //READ
  Future<int> saveItem(TodoItem todoItem) async {
    var dbClient = await db;
    //result of insert is number
    int result = await dbClient.insert(tableTodoList, todoItem.toMap());
    return result;
  }

  Future<List> getAllItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTodoList");
    return result.toList();
  }

  //GET Number of Records
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableTodoList"));
  }

  Future<TodoItem> getTodoItem(int itemId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableTodoList WHERE $columnId = $itemId");
    if (result.length == 0) return null;
    return new TodoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int itemId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableTodoList, where: "$columnId = ?", whereArgs: [itemId]);
  }

  Future<int> updateItem(TodoItem item) async {
    var dbClient = await db;
    return await dbClient.update(tableTodoList, item.toMap(),
        where: "$columnId = ? ", whereArgs: [item.id]);
  }

//Exit connection
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
