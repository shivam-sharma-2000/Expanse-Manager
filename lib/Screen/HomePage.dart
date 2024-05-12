import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_manager/Screen/TransactionDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

import '../database/DBHelper.dart';
import 'AddExpensPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  double cBalance = 0;
  double dBalance = 0;

  DBHelper dbHelper = DBHelper.instance;
  late Database db;
  String sumOfOnlineExpense = "0.00";
  String sumOfCashExpense = "0.00";

  String sumOfOnlineIncome = "0.00";
  String sumOfCashIncome = "0.00";

  late List<Map<String, Object?>> listOfPassBookEntry = [];

  var pad = const EdgeInsets.only(left: 20, right: 20, bottom: 20);
  var subTitle = const TextStyle(fontFamily: "Roboto Mono", fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
  var subTitle1 = const TextStyle(fontFamily: "Roboto Mono", fontSize: 15, color: Colors.white);
  var subTitleBlack = const TextStyle(fontFamily: "Roboto Mono", fontSize: 15, color: Colors.black);
  var subTitleGrey = const TextStyle(fontFamily: "Roboto Mono", fontSize: 15, color: Colors.grey);
  var headingTitle = const TextStyle(fontFamily: "Roboto Mono", fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white);
  var headingTitle1 = const TextStyle(fontFamily: "Roboto Mono", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black);
  var subHeadingTitle = const TextStyle(fontFamily: "Roboto Mono", color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);

  late Map<String, double> dataMap;


  @override
  void initState(){
    initializeDB().then((value){
      getCurrentBalance();
      getDailyExpense();
      getTodayIncomes();
    });
    super.initState();
  }

  Future<void> initializeDB() async{
    db = await dbHelper.database;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        /*appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
          title: const Text("Expense Manager App", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        ),*/
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height/3,
                  width: double.infinity,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.person, color: Colors.white,),
                                const SizedBox(width: 10,),
                                Text("Shivam Sharma", style: subTitle,),
                              ],
                            ),
                            GestureDetector(
                              child: const Icon(Icons.view_list_rounded, color: Colors.white,),
                              onTap: (){
                                showActionView(context);
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text("Monthly Income", style: subTitle1),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(LineIcons.indianRupeeSign, color: Colors.white,),
                                    Text("${cBalance}", style: headingTitle),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Monthly Expense", style: subTitle1),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(LineIcons.indianRupeeSign, color: Colors.white,),
                                    Text("${dBalance}", style: headingTitle),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ExpenseAndReceivePage(from: "Spend"))
                                    ).then((value){
                                      initState();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.1),
                                        borderRadius: const BorderRadius.all(Radius.circular(15))
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(LineIcons.arrowCircleUp, color: Colors.white, size: 30,),
                                          Text("Spend", style: TextStyle(color: Colors.white, fontSize: 20),),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            const SizedBox(width: 20,),
                            Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseAndReceivePage( from: "Receive",total: cBalance,) )
                                    ).then((value){
                                      initState();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.1),
                                        borderRadius: const BorderRadius.all(Radius.circular(15))
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(LineIcons.arrowCircleDown, color: Colors.white, size: 30, ),
                                          Text("Receive", style: TextStyle(color: Colors.white, fontSize: 20),),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 2*MediaQuery.sizeOf(context).height/3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20,),
                        Text("Today Total Expense", style: subHeadingTitle),
                        const SizedBox(height: 40,),
                        sumOfCashExpense != "0.00" || sumOfOnlineExpense != "0.00"
                          ? PieChart(
                          dataMap: {
                            'Online': double.parse(sumOfOnlineExpense),
                            'Cash': double.parse(sumOfCashExpense)
                          },
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 50,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          colorList: [
                            Colors.deepPurple,
                            Colors.black38,
                          ],
                          initialAngleInDegree: 30,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 25,
                          centerText: "Pie Chart",
                          legendOptions: const LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: true,
                            showChartValueBackground: true,
                            chartValueBackgroundColor: Colors.transparent.withOpacity(.1)
                          ),
                        )
                          : Center(child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            child: Text("No Expenses Today", style: subTitleGrey,),
                          )),

                        const SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Transaction", style: subHeadingTitle),
                            TextButton(onPressed: (){}, child: Text("See All", style: TextStyle(color: Colors.green,),))
                          ],
                        ),
                        const SizedBox(height: 20,),
                        listOfPassBookEntry.isNotEmpty ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: listOfPassBookEntry.length,
                              itemBuilder: (context, index){
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context)=> TransactionDetails(
                                              transaction: listOfPassBookEntry.elementAt(index),
                                            ),
                                        ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Material(
                                      elevation: 1,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(.5),
                                                    borderRadius: BorderRadius.circular(100)
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: listOfPassBookEntry.elementAt(index)["transaction_method"]=="credit"
                                                        ? Icon(LineIcons.arrowCircleDown, color: Colors.green,)
                                                        : Icon(LineIcons.arrowCircleUp, color: Colors.green,),
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${listOfPassBookEntry.elementAt(index)["category"]}"),
                                                    Row(
                                                      children: [
                                                        Text("${listOfPassBookEntry.elementAt(index)["time"]}"),
                                                        SizedBox(width: 10,),
                                                        Text("${listOfPassBookEntry.elementAt(index)["date"]}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            listOfPassBookEntry.elementAt(index)["transaction_method"]=="credit"
                                            ?Text(
                                              "+ ₹${listOfPassBookEntry.elementAt(index)["amount"]}",
                                              style: TextStyle(color: Colors.green),
                                            )
                                            :Text(
                                              "- ₹${listOfPassBookEntry.elementAt(index)["amount"]}",
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ):
                        Center(child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Text("Transaction Not Available", style: subTitleGrey,),
                        )),
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

  void getDailyExpense() async{
    double total = await dbHelper.retrieveTodayExpense(db, "online");
    if(total != 0){
      setState(() {
        sumOfOnlineExpense = total.toString();
      });
    }
    total = await dbHelper.retrieveTodayExpense(db, "cash");
    if(total != 0){
      setState(() {
        sumOfCashExpense = total.toString();
      });
    }
  }

  void getIncomes() async{
    double total = await dbHelper.retrieveTotalIncome(db, "online");
    if(total != 0){
      setState(() {
        sumOfOnlineIncome = total.toString();
      });
    }
    total = await dbHelper.retrieveTodayExpense(db, "cash");
    if(total != 0){
      setState(() {
        sumOfCashIncome = total.toString();
      });
    }
  }

  void getTodayIncomes() async{
    double total = await dbHelper.retrieveTodayIncome(db, "online");
    if(total != 0){
      setState(() {
        sumOfOnlineIncome = total.toString();
      });
    }
    total = await dbHelper.retrieveTodayIncome(db, "cash");
    if(total != 0){
      setState(() {
        sumOfCashIncome = total.toString();
      });
    }
  }


  void getCurrentBalance() async {
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    String sd  = DateFormat("yyyy-MM-dd").format(DateTime(year, month, 1));
    String ed  = DateFormat("yyyy-MM-dd").format(DateTime(year, month+1, 1).subtract(Duration(days: 1)));
    var list = await dbHelper.retrieveListOfPassBookEntry(db);
    var cB = await dbHelper.retrieveMonthlyBalance(db, sd, ed, "credit");
    var dB = await dbHelper.retrieveMonthlyBalance(db, sd, ed, "debit");
    setState(() {
      listOfPassBookEntry = list;
      cBalance = cB;
      dBalance = dB;
    });
  }

  Future<void> _showMyDialog() async{
    showDialog(context: context, builder: (context){
      return AlertDialog(
        elevation: 10,
        title: Text("Insufficient Balance", style: headingTitle1, ),
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
                }, child: const Text("OK")),
          )
        ],
      );
    });
  }


}

class Data{
  Data(this.category, this.value);
  final String category;
  final double value;
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