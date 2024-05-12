import 'package:expense_manager/model/database/ExpenseEntryMainModel.dart';
import 'package:expense_manager/model/database/PassBookEntryMainModel.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  final List<String> _listOfIncomes = ["Rent", "Salary", "Other"];
  final List<String> _listOfCategories = ["Milk", "Vegetable", "Food", "Travel","Grocery", "Beauty","Health","Education","Gift","Garments","Pets","Social Life","Rent"];
  final List<String> _listOfMethods = ["online", "cash"];

  static final DBHelper instance = DBHelper._privateConstructor();
  static final int _databaseVersion = 1;

  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async{


    await db.execute("CREATE TABLE expenses ( expense_id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, time TEXT, amount TEXT, method TEXT, category TEXT, note TEXT)");

    await db.execute("CREATE TABLE incomes (income_id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, time TEXT, amount TEXT, method TEXT, category TEXT, note TEXT)");

    await db.execute("CREATE TABLE categories ( category_id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT)");

    await db.execute("CREATE TABLE methods ( method_id INTEGER PRIMARY KEY AUTOINCREMENT, method TEXT)");

    for(int i =0; i<_listOfCategories.length; i++){
      await db.rawInsert("INSERT INTO categories (category) VALUES (?)", [_listOfCategories[i].toString()]
      );
    }

    await db.execute("CREATE TABLE pass_book ( entry_id INTEGER PRIMARY KEY AUTOINCREMENT, total_balance TEXT, date TEXT, time TEXT, amount TEXT, transaction_method TEXT, category Text)");

    await db.execute("CREATE TABLE incomesCategories ( method_id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT)");
    for(int i =0; i<_listOfIncomes.length; i++){
      await db.rawInsert("INSERT INTO incomesCategories (category) VALUES (?)", [_listOfIncomes[i].toString()]
      );
    }

    for(int i =0; i< _listOfMethods.length; i++){
      await db.rawInsert("INSERT INTO methods (method) VALUES (?)", [_listOfMethods[i].toString()]);
    }

  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if(oldVersion < 3){
      for(int i =0; i< _listOfMethods.length; i++){
        await db.rawInsert("INSERT INTO methods (method) VALUES (?)", [_listOfMethods[i].toString()]);
      }
    }
    if(oldVersion < 4){
      await db.execute("CREATE TABLE incomesCategories ( method_id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT)");
      for(int i =0; i<_listOfIncomes.length; i++){
        await db.rawInsert("INSERT INTO incomesCategories (category) VALUES (?)", [_listOfIncomes[i].toString()]
        );
      }
    }
    if(oldVersion < 5){
      await db.execute("CREATE TABLE pass_book ( entry_id INTEGER PRIMARY KEY AUTOINCREMENT, total_balance TEXT, date TEXT, time TEXT, amount TEXT, transaction_method TEXT)");
    }
  }

  Future<List<Map<String, Object?>>> retrieveListOfExpenses(Database db) async{
    List<Map<String, Object?>> list = await db.rawQuery("Select * from categories");
    return list;
  }

  Future<List<Map<String, Object?>>> retrieveListOfMethods(Database db) async{
    List<Map<String, Object?>> list = await db.rawQuery("Select * from methods");
    return list;
  }

  Future<List<Map<String, Object?>>> retrieveListOfIncomes(Database db) async{
    List<Map<String, Object?>> list = await db.rawQuery("Select * from incomesCategories");
    return list;
  }

  Future<double> retrieveMonthlyBalance(Database db, String sd, String ed, String method) async{
    List<Map<String, Object?>> list = await db.rawQuery("SELECT amount FROM pass_book WHERE transaction_method='$method' and date > '$sd' and date< '$ed' ORDER BY entry_id DESC");
    double rValue = 0;
    print(list);
    if(list.isNotEmpty){
      for(int i =0; i<list.length; i++){
        rValue = rValue + double.parse(list.elementAt(0)["amount"].toString());
      }

    }
    return rValue;
  }

  Future<List<Map<String, Object?>>> retrieveListOfPassBookEntry(Database db) async{
    List<Map<String, Object?>> list = await db.rawQuery("SELECT * FROM pass_book ORDER BY entry_id DESC");
    return list;
  }

  Future<int> addExpenseEntry(Database db, ExpenseEntryMainModel ex) async{
   int id =  await db.rawInsert(
        "INSERT INTO expenses (date, time, amount, method, category, note ) VALUES (?,?,?,?,?,?)",
        [ ex.date, ex.time, ex.amount, ex.method, ex.category, ex.note ]
    );
   return id;
  }

  Future<int> addIncomeEntry(Database db, ExpenseEntryMainModel ex) async{
    int id =  await db.rawInsert(
        "INSERT INTO incomes (date, time, amount, method, category, note ) VALUES (?,?,?,?,?,?)",
        [ ex.date, ex.time, ex.amount, ex.method, ex.category, ex.note ]
    );
    return id;
  }

  Future<int> updatePassBook(Database db, PassBookEntryMainModel ex) async{
    int id =  await db.rawInsert(
        "INSERT INTO pass_book (total_balance, date, time, amount, transaction_method, category) VALUES (?,?,?,?,?,?)",
        [ ex.total_balance, ex.date, ex.time, ex.amount, ex.transaction_method, ex.category ]
    );
    return id;
  }



  Future<double> retrieveTodayExpense(Database db, String method) async{
    String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    double total = 0;
    List<Map<String, Object?>> list = await db.rawQuery("Select * from expenses where method = ? AND date = ? ",['$method', '${todayDate}']);
    for(int i =0; i<list.length; i++){
      total = total + double.parse(list.elementAt(i)["amount"].toString());
    }
    return total;
  }

  Future<double> retrieveTodayIncome(Database db, String method) async{
    String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    double total = 0;
    // List<Map<String, Object?>> list = await db.rawQuery("Select amount from expenses where method = '$method' AND date = ${DateTimeFormat.format(DateTime.now(), format: "Y-m-d").toString()}");
    List<Map<String, Object?>> list = await db.rawQuery("Select * from incomes where method = ? AND date = ? ",['$method', '${todayDate}']);
    // List<Map<String, Object?>> list = await db.rawQuery("Select * from expenses");
    for(int i =0; i<list.length; i++){
      total = total + double.parse(list.elementAt(i)["amount"].toString());
      print(list.elementAt(i).toString());
    }
    return total;
  }

  Future<double> retrieveTotalIncome(Database db, String method) async{
    String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    double total = 0;
    // List<Map<String, Object?>> list = await db.rawQuery("Select amount from expenses where method = '$method' AND date = ${DateTimeFormat.format(DateTime.now(), format: "Y-m-d").toString()}");
    List<Map<String, Object?>> list = await db.rawQuery("Select * from incomes where method = ?",['$method']);
    // List<Map<String, Object?>> list = await db.rawQuery("Select * from expenses");
    for(int i =0; i<list.length; i++){
      total = total + double.parse(list.elementAt(i)["amount"].toString());
      print(list.elementAt(i).toString());
    }
    return total;
  }


}
