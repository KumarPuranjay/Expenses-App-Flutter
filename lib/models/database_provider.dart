import 'dart:math';

import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/icons.dart';

class DatabaseProvider with ChangeNotifier{

  Database? _database;

  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value){
    _searchText = value;
    // when searched text changes, widgets will be notified
    notifyListeners();
  }


  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  List<Expense> _expenses = [];
  List<Expense> get expenses {
    if(_searchText == ''){
      return _expenses;
    }
    else{
      return _expenses.where(
              (element) => element.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }
  // Using getters in dart
  Future<Database> get database async{
    // database directory
    final dbDirectory = await getDatabasesPath();
    // database name
    const dbName = 'expense_tc.db';
    // full path
    final path = join(dbDirectory,dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb
    );

    return _database!;
  }

  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';
  Future<void> _createDb(Database db, int version) async{
    await db.transaction((txn) async{
      await txn.execute('''CREATE TABLE $cTable(
        title TEXT,
        entries INTEGER,
        totalAmount TEXT
      )''');

      await txn.execute('''CREATE TABLE $eTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        date TEXT,
        category TEXT
      )''');

      // insert entries in database with entries = 0 and totalAmount = 0.0
      for(int i = 0; i < icons.length; i++){
        await txn.insert(cTable,{
          'title' : icons.keys.toList()[i],
          'entries' : 0,
          'totalAmount' : 0.0
        });
      }

    });

  }

  Future<List<ExpenseCategory>> fetchCategories() async{
    final db = await database; // get database

    return await db.transaction((txn) async{
      return await txn.query(cTable).then((data) {
        // data is fetched value to be converted from Map<String,Object> to Map<String,dynamic>
        final converted = List<Map<String,dynamic>>.from(data);

        List<ExpenseCategory> nList = List.generate(converted.length, (index) =>
          ExpenseCategory.fromString(converted[index])
        );

        _categories = nList;
        return _categories;
      });
    });

  }

  Future<void> updateCategory(
      String category,
      int nEntries,
      double nTotalAmount
      ) async{

    final db = await database;
    await db.transaction((txn) async {
      txn.update(cTable, {
        'entries': nEntries.toString(),
        'totalAmount': nTotalAmount.toString()
      },
      where: 'title == ?', whereArgs: [category]
      ).then((value){
        // updating our _categories list
        var file = _categories.firstWhere((element) => element.title == category);
        file.entries = nEntries;
        file.totalAmount = nTotalAmount;
        notifyListeners();
      });
    });

  }

  Future<List<Expense>> fetchExpenses(String category) async{
    final db = await database;
    return await db.transaction((txn) async{
      return await txn.rawQuery('SELECT * FROM $eTable WHERE category = ?',[category])
          .then((data) {
            final convertedList = List<Map<String,dynamic>>.from(data);
            List<Expense> nList = List
                .generate(
                convertedList.length, (index) => Expense.fromString(convertedList[index])
            );
            _expenses = nList;
            return _expenses;
      });
    });
  }

  Future<List<Expense>> fetchAllExpenses() async{
    final db = await database;
    return await db.transaction((txn) async{
      return await txn.query(eTable)
          .then((data) {
            final convertedList = List<Map<String,dynamic>>.from(data);
            _expenses = List
                .generate(
                convertedList.length, (index) => Expense.fromString(convertedList[index])
            );
            return _expenses;
      });
    });
  }

  // add expenses to database
  Future<void> addExpense(Expense expense) async{
    final db = await database;
    await db.transaction((txn) async {
      txn.insert(
          eTable,
          expense.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }).then((generatedId){
      final file = Expense(
          id: Random().nextInt(10000),
          title: expense.title,
          amount: expense.amount,
          date: expense.date,
          category: expense.category
      );
      notifyListeners();
      _expenses.add(file);
      // updating categories
      var data = findCategory(expense.category);
      updateCategory(expense.category, data.entries + 1, data.totalAmount + expense.amount);
    });
  }
  
  Future<void> deleteExpense(int expenseId,String category, double amount) async{
    final db = await database;
    await db.transaction((txn) async{
      return await txn
          .delete(eTable,where: 'id == ?',whereArgs: [expenseId])
          .then((_) {
            _expenses.removeWhere((element) => element.id == expenseId);
            notifyListeners();
            // update entries and totalAmount
            var data = findCategory(category);
            updateCategory(category, data.entries - 1, data.totalAmount - amount);

      });
    });
  }

  ExpenseCategory findCategory(String title){
    return _categories.firstWhere((element) => element.title == title);
  }

  double calculateTotalExpenses(){
    double totalSum = 0.0;
    for (var i in _categories){
      totalSum += i.totalAmount;
    }
    return totalSum;
  }

  Map<String,dynamic> calculateEntriesAmount(String category){
    double total = 0.0;
    var list = _expenses.where((element) => element.category == category);
    for(final i in list){
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  List<Map<String,dynamic>> calculateWeekExpenses(){
    List<Map<String,dynamic>> dayExpensesList = [];

    // we know that we need 7 entries
    for(int i = 0; i < 7; i++){
      // 1 total for each entry
      double total = 0.0;
      // Subtract i from today to get previous dates
      final weekDay = DateTime.now().subtract(Duration(days: i));

      // Number of transaction on that day
      for(var i in _expenses){
        if(i.date.year == weekDay.year &&
            i.date.month == weekDay.month &&
            i.date.day == weekDay.day){
          total += i.amount;
        }
      }
      dayExpensesList.add({'day':weekDay, 'amount':total});
    }
    return dayExpensesList;
  }

}