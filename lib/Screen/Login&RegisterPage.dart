import 'package:expense_manager/Screen/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../database/DBHelper.dart';
import '../model/database/PassBookEntryMainModel.dart';

class LoginAndRegisterPage extends StatefulWidget {
  const LoginAndRegisterPage({super.key});

  @override
  State<LoginAndRegisterPage> createState() => _LoginAndRegisterPageState();
}

class _LoginAndRegisterPageState extends State<LoginAndRegisterPage> {
  late Database db;
  DBHelper dbHelper = DBHelper.instance;

  var pad = const EdgeInsets.only(left: 20, right: 20, bottom: 20);
  var subTitle = const TextStyle(fontFamily: "Roboto Mono" ,fontWeight: FontWeight.bold, fontSize: 16);
  var headingTitle = const TextStyle(fontFamily: "Roboto Mono" ,fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black);
  var subHeadingTitle = const TextStyle(fontFamily: "Roboto Mono" ,color: Colors.black, fontSize: 16);

  TextEditingController amount = TextEditingController(text: "");

  Future<void> initializeDB() async{
    db = await dbHelper.database;
  }

  @override
  void initState() {
    initializeDB();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: pad,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Text("Regiter",
                style: headingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name", style: subTitle),
                  const SizedBox(height: 5,),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Please Enter your Name",
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
                  Text("Number", style: subTitle),
                  const SizedBox(height: 5,),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "+91 6266097183",
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
                  Text("Initial Account Balance ( including online and cash )", style: subTitle),
                  const SizedBox(height: 5,),
                  TextField(
                    controller : amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Please Enter Initial Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  if(amount.text.isNotEmpty){
                    PassBookEntryMainModel pB = PassBookEntryMainModel(
                        DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
                        DateFormat("hh:mm").format(DateTime.now()).toString(),
                        "0",
                        "",
                        "${amount.text}",
                        ""
                    );
                    dbHelper.updatePassBook(db, pB).then((value){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
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
                    child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
