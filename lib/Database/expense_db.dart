import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../Models/Expense/expense.dart';
import 'package:intl/intl.dart';

class DBProvider {
  static Database _database;

  DateFormat _dt = DateFormat('yyyy-MM-dd');

  Future<Database> get _db async {
    if (_database != null) return _database;
    _database = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "profiles.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _create);
    return theDb;
  }

  void _create(Database db, int version) async {
    await db.execute("""CREATE TABLE expense(
      id INTEGER PRIMARY KEY autoincrement,
      item TEXT NOT NULL,
      price REAL NOT NULL,
      category TEXT NOT NULL,
      date TEXT NOT NULL,
      year TEXT NOT NULL)""");
    print("Expense Table Created");
  }

  Future<void> addExpense(Expense expense) async {
    var dbClient = await _db;
    await dbClient.transaction((txn) async {
      return await txn.insert("expense", expense.toMap());
    });
  }

  Future<List<Expense>> getLastExpense() async {
    var today = _dt.format(DateTime.now());
    var dbClient = await _db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT * FROM expense WHERE date LIKE '$today' ORDER BY id DESC");
    List<Expense> expenseList = List();
    for (var i = 0; i < list.length; i++) {
      expenseList.add(Expense(
          id: list[i]['id'],
          item: list[i]['item'],
          amount: list[i]['price'],
          category: list[i]['category'],
          date: list[i]['date'],
          year: list[i]['year']));
    }
    return expenseList;
  }

  Future<List<Expense>> historyExpense(String selectedDate) async {
    var dbClient = await _db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT * FROM expense WHERE date = '$selectedDate' ORDER BY id DESC");
    List<Expense> expenseList = List();
    for (var i = 0; i < list.length; i++) {
      expenseList.add(Expense(
          id: list[i]['id'],
          item: list[i]['item'],
          amount: list[i]['price'],
          category: list[i]['category'],
          date: list[i]['date'],
          year: list[i]['year']));
    }
    return expenseList;
  }

  Future<List<Expense>> lastSevenDays(String date) async {
    var dbClient = await _db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT * FROM expense WHERE date = '$date' ORDER BY id DESC");
    List<Expense> expenseList = List();
    for (var i = 0; i < list.length; i++) {
      expenseList.add(Expense(
          id: list[i]['id'],
          item: list[i]['item'],
          amount: list[i]['price'],
          category: list[i]['category'],
          date: list[i]['date'],
          year: list[i]['year']));
    }
    return expenseList;
  }

  void updateExpense(Expense expense) async {
    var dbClient = await _db;
    await dbClient.transaction((txn) async {
      await txn.update("expense", expense.toMap(),
          where: "id = ?", whereArgs: [expense.id]);
    });
  }

  void deleteExpense(int expenseID) async {
    var dbClient = await _db;
    await dbClient.transaction((txn) async {
      return await txn
          .delete("expense", where: "id = ?", whereArgs: [expenseID]);
    });
  }
}
