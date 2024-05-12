import 'package:flutter/material.dart';

class TransactionDetails extends StatefulWidget {
  final Map<String, Object?> transaction;
  const TransactionDetails({super.key, required this.transaction});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {

  var pad = const EdgeInsets.only(left: 20, right: 20, bottom: 20);
  var subTitle = const TextStyle(fontFamily: "Roboto Mono" ,fontWeight: FontWeight.bold, fontSize: 16);
  var headingTitle = const TextStyle(fontFamily: "Roboto Mono" ,fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black);
  var subHeadingTitle = const TextStyle(fontFamily: "Roboto Mono" ,color: Colors.black, fontSize: 16);

  TextEditingController amount = TextEditingController(text: "");
  TextEditingController category = TextEditingController(text: "");
  TextEditingController method = TextEditingController(text: "");
  TextEditingController id = TextEditingController(text: "");


  @override
  void initState() {
    amount.text = widget.transaction['amount'].toString();
    category.text = widget.transaction['category'].toString();
    method.text = widget.transaction['transaction_method'].toString();
    id.text = widget.transaction['entry_id'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: pad,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Text("Transaction Details",
                style: headingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10,),
              /*Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(widget.from == "Receive"
                    ? "Please enter your income details here!"
                    : "Please enter your expense details here!",
                  style: subHeadingTitle,
                  textAlign: TextAlign.center,
                ),
              ),*/
              const SizedBox(height: 40,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Transaction Id", style: subTitle),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: id,
                    readOnly: true,
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
                  Text("Amount", style: subTitle),
                  const SizedBox(height: 5,),
                  TextField(
                    controller: amount,
                    readOnly: true,
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
                    decoration: InputDecoration(
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
                    decoration: InputDecoration(
                        hintText: "Please Select Method",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),)
                ],
              ),
              const SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}
