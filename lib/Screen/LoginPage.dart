import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Card(
                color: Colors.greenAccent.withOpacity(.1), // Set the card's background color
                child: Container(
                  width: 200,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            labelStyle: TextStyle(color: Colors.blue), // Customize label text style
                            border: OutlineInputBorder( // Customize the border
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.blue, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                          ),
                          style: TextStyle(color: Colors.black), // Customize text style
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 80,
              height: 80,
              color: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }
}
