import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/DBHelper.dart';
import 'AddExpensPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  double total = 0;
  double cash = 0;
  double online = 0;

  DBHelper dbHelper = DBHelper.instance;
  late Database db;
  String sumOfOnlineExpense = "0.00";


  @override
  void initState(){
    super.initState();
    total = 16000;
    cash = 4000;
    online = 12000;
    getDailyExpense();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
          title: const Text("Expense Manager App", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        ),*/
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Welcome! Shivam Sharma", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    GestureDetector(
                      child: const Icon(Icons.view_list_rounded),
                      onTap: (){
                        showActionView(context);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                const Text("Total Balance", style: TextStyle(color: Colors.grey, fontSize: 15),),
                const SizedBox(height: 5,),
                Text("₹$total", style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment : CrossAxisAlignment.stretch,
                        children: [
                          const Text("Cash", style: TextStyle(color: Colors.grey, fontSize: 15),),
                          const SizedBox(height: 5,),
                          Text("₹$cash", style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment : CrossAxisAlignment.stretch,
                        children: [
                          const Text("Online", style: TextStyle(color: Colors.grey, fontSize: 15),),
                          const SizedBox(height: 5,),
                          Text("₹$online", style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpensPage(updateEntry: updateEntry)));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.arrow_upward, color: Colors.white, size: 30,),
                                Text("Spend", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.arrow_downward, color: Colors.white, size: 30, ),
                                Text("Receive", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(15),),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15),),
                      border : Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Today Total Expense", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),),
                              Icon(Icons.analytics, color: Colors.black,)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("₹200.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment : CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Cash", style: TextStyle(color: Colors.grey, fontSize: 15),),
                                    SizedBox(height: 5,),
                                    Text(sumOfOnlineExpense, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment : CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Online", style: TextStyle(color: Colors.grey, fontSize: 15),),
                                    SizedBox(height: 5,),
                                    Text("₹60.00", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        border : Border.all(color: Colors.grey),
                        borderRadius: const BorderRadius.all(Radius.circular(15))
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Yesterday Total Expense", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),),
                              Icon(Icons.analytics, color: Colors.black,)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("₹100.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment : CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Cash", style: TextStyle(color: Colors.grey, fontSize: 15),),
                                    SizedBox(height: 5,),
                                    Text("₹100.00", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment : CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Online", style: TextStyle(color: Colors.grey, fontSize: 15),),
                                    SizedBox(height: 5,),
                                    Text("₹0.00", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showActionView(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize:MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 10,),
                const Text("Action View", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),),
                const SizedBox(height: 10,),
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border : Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child : const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 10),
                      child: Text('View Day Wise Expense', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border : Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child : const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 10),
                      child: Text('View Month Wise Expense', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border : Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child : const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 10),
                      child: Text('Analyse Expense', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border : Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child : const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15, left: 10, right: 10),
                      child: Text('Setting', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                // Add more ListTiles for other actions
              ],
            ),
          ),
        );
      },
    );
  }

  void updateEntry(String method, String amount){
    setState(() {
      if(method == ""){
      }else if(method == "Cash"){
        cash = cash - double.parse(amount);
      }
      else{
        online = online - double.parse(amount);
      }
      total = cash + online;
    });
  }


  void getDailyExpense() async{
    db = await dbHelper.database;
    List<Map<String, Object?>> list = await dbHelper.retrieveTodayExpense(db, "online");
    if(list.isNotEmpty){
      setState(() {
        sumOfOnlineExpense = list.elementAt(0)["amount"].toString();
      });
    }
  }

}

/*Material(
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
                      child: Text('Setting', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
                SizedBox(height: 5,),*/