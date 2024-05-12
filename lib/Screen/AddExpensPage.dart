import 'package:expense_manager/model/database/ExpenseEntryMainModel.dart';
import 'package:expense_manager/model/database/PassBookEntryMainModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../database/DBHelper.dart';

class ExpenseAndReceivePage extends StatefulWidget {
  final from;
  final total;
  const ExpenseAndReceivePage({Key? key, required this.from, this.total}) : super(key: key);

  @override
  State<ExpenseAndReceivePage> createState() => _ExpenseAndReceivePageState();


}

class _ExpenseAndReceivePageState extends State<ExpenseAndReceivePage> {
  TextEditingController amount = TextEditingController(text: "");
  TextEditingController category = TextEditingController(text: "");
  TextEditingController method = TextEditingController(text: "");
  TextEditingController note = TextEditingController(text: "");


  DBHelper dbHelper = DBHelper.instance;
  late Database db;
  late List<Map<String, Object?>> listOfExpenseCategory;
  late List<Map<String, Object?>> listOfIncomeCategory;
  late List<Map<String, Object?>> listOfMethods = [];

  var pad = const EdgeInsets.only(left: 20, right: 20, bottom: 20);
  var subTitle = const TextStyle(fontFamily: "Roboto Mono" ,fontWeight: FontWeight.bold, fontSize: 16);
  var headingTitle = const TextStyle(fontFamily: "Roboto Mono" ,fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black);
  var subHeadingTitle = const TextStyle(fontFamily: "Roboto Mono" ,color: Colors.black, fontSize: 16);
  @override
  void initState() {
    initializeDB().then((value){
      getAllCategoryList();
    });
    super.initState();
  }

  Future<void> initializeDB() async{
    db = await dbHelper.database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: pad,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Text(widget.from == "Receive" ? "Incomes" : "Expense",
                style: headingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(widget.from == "Receive"
                    ? "Please enter your income details here!"
                    : "Please enter your expense details here!",
                  style: subHeadingTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Amount", style: subTitle),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category", style: subTitle,),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: category,
                    readOnly: true,
                    onTap: (){
                      if(widget.from == "Receive"){
                        showListInActionView(listOfIncomeCategory, 1);
                      }
                      else{
                        showListInActionView(listOfExpenseCategory, 1);
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.arrow_right),
                        hintText: "Please Select Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                    )
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Method", style: subTitle,),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: method,
                    readOnly: true,
                    onTap: (){
                      showListInActionView(listOfMethods, 2);
                    },
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.arrow_right),
                        hintText: "Please Select Method",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),)
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description", style: subTitle,),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: note,
                    onChanged: (text){
                      setState(() {
                        note.text = text;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Please Enter Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),)
                ],
              ),
              const SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                  if(amount.text.isNotEmpty && method.text.isNotEmpty && category.text.isNotEmpty){
                    ExpenseEntryMainModel ex = ExpenseEntryMainModel(
                        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
                        DateFormat("hh:mm").format(DateTime.now()).toString(),
                        amount.text,
                        method.text,
                        category.text,
                        note.text
                    );
                    PassBookEntryMainModel pB = PassBookEntryMainModel(
                      DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
                      DateFormat("hh:mm").format(DateTime.now()).toString(),
                      amount.text,
                      widget.from == "Receive" ? "credit" : "debit",
                      "",
                      category.text

                    );
                    dbHelper.updatePassBook(db, pB).then((value) {
                      if(widget.from == "Receive"){
                        dbHelper.addIncomeEntry(db, ex).then((value){
                          if(value != 0){
                            _showSuccessDialog();
                          }
                        });
                      }
                      else{
                        dbHelper.addExpenseEntry(db, ex).then((value){
                          if(value != 0){
                            _showSuccessDialog();
                          }
                        });
                      }
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(widget.from, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showListInActionView(List<Map<String, Object?>> list, i){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            Text(i == 1 ?"Select Category Method" :"Select Expense Method", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),),
            const SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        setState((){
                          if(i == 1){
                            category.text = list.elementAt(index)["category"].toString();
                          }
                          if(i == 2){
                            method.text = list.elementAt(index)["method"].toString();
                          }
                          Navigator.pop(context);
                        });
                      },
                      child: Material(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border : Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child : Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 10),
                            child: i == 1
                                ? Text(list.elementAt(index)["category"].toString(), style: const TextStyle(fontWeight: FontWeight.bold),)
                                : Text(list.elementAt(index)["method"].toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20,),
          ],
        );
      },
    );
  }

  void getAllCategoryList () async{
    List<Map<String, Object?>> list1, list2, list3;
    list1 = await dbHelper.retrieveListOfExpenses(db);
    list2 = await dbHelper.retrieveListOfMethods(db);
    list3 = await dbHelper.retrieveListOfIncomes(db);
    setState(() {
      listOfExpenseCategory = list1;
      listOfMethods = list2;
      listOfIncomeCategory = list3;
    });
  }

  Future<void> _showAlertDialog() async{
    showDialog(context: context, builder: (context){
      return AlertDialog(
        elevation: 10,
        title: Text("Insufficient Balance", style: headingTitle, ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("you have Insufficient Balance! Please SetUp Initial Account", style: subHeadingTitle, ),
            ],
          ),
        ),
        actions: [
          Container(
            height: 30,
            child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, child: Text("OK")),
          )
        ],
      );
    });
  }

  Future<void> _showSuccessDialog() async{
    showDialog(context: context, builder: (context){
      return AlertDialog(
        elevation: 10,
        title: Text("Success", style: headingTitle, ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Record Saved Successfully", style: subHeadingTitle, ),
            ],
          ),
        ),
        actions: [
          Container(
            height: 30,
            child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, child: Text("OK")),
          )
        ],
      );
    });
  }

}
