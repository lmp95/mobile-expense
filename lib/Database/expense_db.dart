import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../Models/Expense/expense.dart';
import 'package:intl/intl.dart';
import '../Models/Income/income.dart';
import '../Models/Analystic/categories.dart';
import 'package:flutter/material.dart';
import '../Models/Analystic/annual_expense.dart';
import '../Models/Analystic/annual_category.dart';

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
      month TEXT NOT NULL,
      year TEXT NOT NULL)""");

    await db.execute("""CREATE TABLE income(
      id INTEGER PRIMARY KEY autoincrement,
      description TEXT NOT NULL,
      price REAL NOT NULL,
      date TEXT NOT NULL,
      month TEXT NOT NULL,
      year TEXT NOT NULL)""");
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
          month: list[i]['month'],
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
          month: list[i]['month'],
          year: list[i]['year']));
    }
    return expenseList;
  }

  Future<List<Expense>> specificDateRangeExpense(
      String startDate, endDate) async {
    var dbClient = await _db;
    List<Map> specificDateList = await dbClient.rawQuery(
        "SELECT * FROM expense WHERE date BETWEEN '$startDate' AND '$endDate' ORDER BY date");
    List<Expense> expenseList = List();
    for (var i = 0; i < specificDateList.length; i++) {
      expenseList.add(Expense(
          id: specificDateList[i]['id'],
          item: specificDateList[i]['item'],
          amount: specificDateList[i]['price'],
          category: specificDateList[i]['category'],
          date: specificDateList[i]['date'],
          month: specificDateList[i]['month'],
          year: specificDateList[i]['year']));
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
          month: list[i]['month'],
          year: list[i]['year']));
    }
    return expenseList;
  }

  Future<List<Expense>> getMonthlyExpense(String thisMonth) async {
    var dbClient = await _db;
    List<Map> specificDateList = await dbClient.rawQuery(
        "SELECT * FROM expense WHERE month = '$thisMonth' ORDER BY date");
    List<Expense> expenseList = List();
    for (var i = 0; i < specificDateList.length; i++) {
      expenseList.add(Expense(
          id: specificDateList[i]['id'],
          item: specificDateList[i]['item'],
          amount: specificDateList[i]['price'],
          category: specificDateList[i]['category'],
          date: specificDateList[i]['date'],
          month: specificDateList[i]['month'],
          year: specificDateList[i]['year']));
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

  // Income Methods --------------------------------------------------------------------------------
  Future<void> addIncome(Income income) async {
    var dbClient = await _db;
    await dbClient.transaction((txn) async {
      return await txn.insert("income", income.toMap());
    });
  }

  Future<List<Income>> getMonthlyIncome(String thisMonth) async {
    var dbClient = await _db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT * FROM income WHERE month = '$thisMonth' ORDER BY date DESC");
    List<Income> monthlyIncomeList = List();
    for (var i = 0; i < list.length; i++) {
      monthlyIncomeList.add(Income(
          id: list[i]['id'],
          description: list[i]['description'],
          amount: list[i]['price'],
          date: list[i]['date'],
          month: list[i]['month'],
          year: list[i]['year']));
    }
    return monthlyIncomeList;
  }

  void updateIncome(Income income) async {
    var dbClient = await _db;
    await dbClient.transaction((txn) async {
      await txn.update("income", income.toMap(),
          where: "id = ?", whereArgs: [income.id]);
    });
  }

  void deleteIncome(int incomeID) async {
    var dbClient = await _db;
    await dbClient.transaction((txn) async {
      return await txn.delete("income", where: "id = ?", whereArgs: [incomeID]);
    });
  }

  // Categories Monthly Analystics --------------------------------------------------------------------------------
  Future<List<Categories>> getEachCatMonthExp(
      String thisMonth, String thisYear) async {
    List<Categories> catExpList = List();
    var colorList = [
      Color(0xFFFE5F55),
      Color(0xFF52D1DC),
      Color(0xFF8661C1),
      Color(0xFF7097A8),
      Color(0xFF1EA896),
      Color(0xFFF5853F),
      Color(0xFFFFE787),
      Color(0xFF19647E)
    ];
    var catList = [
      'Clothing',
      'Entertainment',
      'Food',
      'Gifts/Donations',
      'Medical/Healthcare',
      'Personal',
      'Transportation',
      'Utilities'
    ];
    var dbClient = await _db;
    for (var i = 0; i < catList.length; i++) {
      var cat = catList[i];
      var totalExp = 0.0;
      var qResult = await dbClient.rawQuery(
          "SELECT * FROM expense WHERE month = '$thisMonth' AND year='$thisYear' AND category = '$cat' ORDER BY date DESC");
      for (var exp in qResult) {
        totalExp += exp['price'];
      }
      catExpList.add(
        Categories(
          catId: i + 1,
          year: thisYear,
          month: thisMonth,
          totalAmt: totalExp,
          color: colorList[i],
        ),
      );
    }
    return catExpList;
  }

  // Get Specific Category Total Expense List
  Future<List<Expense>> getSpecCateExpList(
      String thisMonth, String thisYear, String cate) async {
    List<Expense> specCatExpList = List();
    var dbClient = await _db;
    var qResult = await dbClient.rawQuery(
        "SELECT * FROM expense WHERE month = '$thisMonth' AND year='$thisYear' AND category = '$cate' ORDER BY date ASC");
    for (var i = 0; i < qResult.length; i++) {
      specCatExpList.add(Expense(
          id: qResult[i]["id"],
          item: qResult[i]['item'],
          amount: qResult[i]['price'],
          category: qResult[i]['category'],
          date: qResult[i]['date'],
          month: qResult[i]['month'],
          year: qResult[i]['year']));
    }
    return specCatExpList;
  }

  // Categories Annual Analystics --------------------------------------------------------------------------------
  // Get Specific Category Total Expense List
  Future<List<Annual>> getAnnualCatExp(String thisYear) async {
    List<Annual> catExpList = List();
    var monthList = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    var catList = [
      'Clothing',
      'Entertainment',
      'Food',
      'Gifts/Donations',
      'Medical/Healthcare',
      'Personal',
      'Transportation',
      'Utilities'
    ];
    var colorList = [
      Color(0xFFFE5F55),
      Color(0xFF52D1DC),
      Color(0xFF8661C1),
      Color(0xFF7097A8),
      Color(0xFF1EA896),
      Color(0xFFF5853F),
      Color(0xFFFFE787),
      Color(0xFF19647E)
    ];
    var dbClient = await _db;
    for (var i = 0; i < catList.length; i++) {
      var cat = catList[i];
      for (var x = 1; x < monthList.length + 1; x++) {
        var month = monthList[x - 1];
        var totalExp = 0.0;
        var qResult = await dbClient.rawQuery(
            "SELECT * FROM expense WHERE month = '$x' AND year='$thisYear' AND category = '$cat' ORDER BY date DESC");
        for (var exp in qResult) {
          totalExp += exp['price'];
        }
        catExpList.add(
          Annual(
            category: catList[i],
            year: thisYear,
            month: month,
            totalAmt: totalExp,
            color: colorList[i],
          ),
        );
      }
    }
    return catExpList;
  }

  // Annual Expense of each Category -------------------------------------------------------
  Future<List<AnnualCategory>> annualCatExp(String thisYear) async {
    List<AnnualCategory> catExpList = List();
    var catList = [
      'Clothing',
      'Entertainment',
      'Food',
      'Gifts/Donations',
      'Medical/Healthcare',
      'Personal',
      'Transportation',
      'Utilities'
    ];
    var colorList = [
      Color(0xFFFE5F55),
      Color(0xFF52D1DC),
      Color(0xFF8661C1),
      Color(0xFF7097A8),
      Color(0xFF1EA896),
      Color(0xFFF5853F),
      Color(0xFFFFE787),
      Color(0xFF19647E)
    ];
    var dbClient = await _db;
    for (var i = 0; i < catList.length; i++) {
      var cat = catList[i];
      var totalExp = 0.0;
      var qResult = await dbClient.rawQuery(
          "SELECT * FROM expense WHERE year='$thisYear' AND category = '$cat' ORDER BY date DESC");
      for (var exp in qResult) {
        totalExp += exp['price'];
      }
      catExpList.add(AnnualCategory(
          category: i + 1,
          color: colorList[i],
          totalAmt: totalExp,
          year: thisYear));
    }
    return catExpList;
  }

  // Annual Each Category Expense List -------------------------------------------------------
  Future<List<Expense>> annualCatExpList(String thisYear, String cate) async {
    List<Expense> annualExpList = List();
    var dbClient = await _db;
    var qResult = await dbClient.rawQuery(
        "SELECT * FROM expense WHERE year='$thisYear' AND category = '$cate' ORDER BY date ASC");
    for (var i = 0; i < qResult.length; i++) {
      annualExpList.add(Expense(
          id: qResult[i]["id"],
          item: qResult[i]['item'],
          amount: qResult[i]['price'],
          category: qResult[i]['category'],
          date: qResult[i]['date'],
          month: qResult[i]['month'],
          year: qResult[i]['year']));
    }
    return annualExpList;
  }

  // Weekly Category Expense List -------------------------------------------------------
  // Future<List<Expense>> weekExpenseList(String thisYear, String cate) async {
  //   List<Expense> annualExpList = List();
  //   var dbClient = await _db;
  //   var qResult = await dbClient.rawQuery(
  //       "SELECT * FROM expense WHERE year='$thisYear' AND category = '$cate' ORDER BY date ASC");
  //   for (var i = 0; i < qResult.length; i++) {
  //     annualExpList.add(Expense(
  //         id: qResult[i]["id"],
  //         item: qResult[i]['item'],
  //         amount: qResult[i]['price'],
  //         category: qResult[i]['category'],
  //         date: qResult[i]['date'],
  //         month: qResult[i]['month'],
  //         year: qResult[i]['year']));
  //   }
  //   return annualExpList;
  // }
}
