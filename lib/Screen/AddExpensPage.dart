import 'package:date_time_format/date_time_format.dart';
import 'package:expense_manager/model/database/ExpenseEntryMainModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/DBHelper.dart';

class AddExpensPage extends StatefulWidget {
  final Function updateEntry;
  const AddExpensPage({Key? key, required this.updateEntry}) : super(key: key);

  @override
  State<AddExpensPage> createState() => _AddExpensPageState();
}

class _AddExpensPageState extends State<AddExpensPage> {
  TextEditingController amount = TextEditingController(text: "");
  TextEditingController category = TextEditingController(text: "");
  TextEditingController method = TextEditingController(text: "");
  TextEditingController note = TextEditingController(text: "");


  DBHelper dbHelper = DBHelper.instance;
  late Database db;
  late List<Map<String, Object?>> listOfExpenseCategory;
  late List<Map<String, Object?>> listOfMethods;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20,),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(15),),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15),),
                border : Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Enter Expense Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),),
                        Icon(Icons.analytics, color: Colors.black,)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only( left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 4, child: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                        Expanded(
                          flex: 6,
                          child: Container(
                            height: 20,
                            child: TextField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(

                              ),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only( left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 4, child: Text("Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                        Expanded(
                          flex: 6,
                          child: Container(
                            height: 20,
                            child: TextField(
                              controller: category,
                              readOnly: true,
                              onTap: (){
                                showListInActionView(listOfExpenseCategory, 1);
                              },
                              decoration: InputDecoration(

                              ),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only( left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 4, child: Text("Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                        Expanded(
                          flex: 6,
                          child: Container(
                            height: 20,
                            child: TextField(
                              controller: method,
                              readOnly: true,
                              onTap: (){
                                showListInActionView(listOfMethods, 2);
                              },
                              decoration: InputDecoration(

                              ),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only( left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 4, child: Text("Note", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
                        Expanded(
                          flex: 6,
                          child: Container(
                            height: 20,
                            child: TextField(
                              controller: note,
                              onChanged: (text){
                                setState(() {
                                  note.text = text;
                                });
                              },
                              decoration: InputDecoration(

                              ),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: (){
                          if(amount.text.isNotEmpty && method.text.isNotEmpty && category.text.isNotEmpty){
                            ExpenseEntryMainModel ex = ExpenseEntryMainModel(
                                DateTimeFormat.format(DateTime.now(), format: "Y-m-d").toString(),
                                DateTimeFormat.format(DateTime.now(), format: "h:i").toString(),
                                amount.text,
                                method.text,
                                category.text,
                                note.text
                            );
                            dbHelper.addExpenseEntry(db, ex).then((value){
                              if(value != 0){
                                widget.updateEntry(method.text, amount.text);
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("Spend", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ],
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
            SizedBox(height: 10,),
            Text("Select Expense Method", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),),
            SizedBox(height: 10,),
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
                          if(i ==1){
                            category.text = list.elementAt(index)["category"].toString();
                          }
                          if(i == 2){
                            method.text = list.elementAt(index)["method"].toString();
                          }
                          Navigator.pop(context);
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child : Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 10),
                            child: i == 1
                                ? Text(list.elementAt(index)["category"].toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                                : Text(list.elementAt(index)["method"].toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void getExpenseList () async{
    db = await dbHelper.database;
    List<Map<String, Object?>> list1, list2;
    list1 = await dbHelper.retrieveListOfExpenses(db);
    list2 = await dbHelper.retrieveListOfMethods(db);
    setState(() {
      listOfExpenseCategory = list1;
      listOfMethods = list2;
    });
  }
}
