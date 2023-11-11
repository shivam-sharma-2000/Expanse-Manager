import 'package:date_time_format/date_time_format.dart';
import 'package:expense_manager/model/database/ExpenseEntryMainModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  final List<String> _listOfCategories = ["Milk", "Vegetable", "Food", "Travel", "Beauty","Health","Education","Gift","Garments","Pets","Social Life","Rent"];

  final List<String> _listOfMethods = ["online", "cash"];

  static final DBHelper instance = DBHelper._privateConstructor();
  static final int _databaseVersion = 2;

  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
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


  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if(oldVersion < 2){
      for(int i =0; i< _listOfMethods.length; i++){
        await db.rawInsert("INSERT INTO methods (method) VALUES (?)", [_listOfMethods[i].toString()]
        );
      }
    }
  }

  Future<List<Map<String, Object?>>> retrieveListOfExpenses(Database db) async{
    List<Map<String, Object?>> list = await db.rawQuery("Select * from categories");
    return list;
  }

  Future<List<Map<String, Object?>>> retrieveListOfMethods(Database db) async{
    List<Map<String, Object?>> list = await db.rawQuery("Select * from methods");
    print(list.elementAt(0).toString());
    return list;
  }

  Future<int> addExpenseEntry(Database db, ExpenseEntryMainModel ex) async{
   int id =  await db.rawInsert(
        "INSERT INTO expenses (date, time, amount, method, category, note ) VALUES (?,?,?,?,?,?)",
        [ ex.date, ex.time, ex.amount, ex.method, ex.category, ex.note ]
    );
   return id;
  }

  Future<List<Map<String, Object?>>> retrieveTodayExpense(Database db, String method) async{
    // List<Map<String, Object?>> list = await db.rawQuery("Select amount from expenses where method = '$method' AND date = ${DateTimeFormat.format(DateTime.now(), format: "Y-m-d").toString()}");
    List<Map<String, Object?>> list = await db.rawQuery("Select * from expenses where method = ? AND date = ? ",['$method', '${DateTimeFormat.format(DateTime.now().subtract(Duration(days: 1)), format: "Y-m-d").toString()}']);
    // List<Map<String, Object?>> list = await db.rawQuery("Select * from expenses");
    print(list.elementAt(0).toString());
    return list;
  }

}
