import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'Login&RegisterPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CarouselSlider(
                items: [
                  // Replace these containers with your desired widgets for each slide
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('1.', style: TextStyle(color: Colors.white, fontSize: 50.0),),
                        ),

                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Register & Set Up Your Initial Account', style: TextStyle(color: Colors.white, fontSize: 35.0),),
                        ),

                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('2.', style: TextStyle(color: Colors.white, fontSize: 50.0),),
                        ),

                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('Add and Monitor your Expense and Incomes', style: TextStyle(color: Colors.white, fontSize: 35.0),),
                        ),

                      ],
                    ),
                  ),
                  // Add more containers or widgets for additional slides as needed
                ],
                options: CarouselOptions(
                  height: 400.0, // Set the height of the carousel
                  autoPlay: true, // Set to true for automatic sliding
                  enlargeCenterPage: true, // Set to true to make the center item larger
                  aspectRatio: 16 / 9, // Set the aspect ratio of the carousel
                  autoPlayCurve: Curves.fastOutSlowIn, // Set the animation curve
                  autoPlayInterval: const Duration(seconds: 5), // Set the duration between slides
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000), // Set the animation duration
                  enableInfiniteScroll: false, // Set to false to disable infinite scroll
                  // Other carousel options can be added here
                ),
              ),
              Column(children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Continue without initial account",textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginAndRegisterPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.blueAccent]
                        ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Register & SetUp Initial Account",textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
