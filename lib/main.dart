import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:karten/google_sign_in_ui.dart';
import 'package:karten/locate_splash_screen.dart';
import 'package:karten/page1.dart';
import 'package:karten/page2.dart';
import 'package:karten/page3.dart';
import 'package:karten/page4.dart';
import 'package:karten/page5.dart';

import 'getter_database_service.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MaterialApp(
    home: const SignUpPage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
  ));
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List wig = [Page1(), Page2(), Page3(), Page4(), Page5()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: Colors.white,
      body: wig[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        isFloating: true,
        elevation: 0,
        blurEffect: false,
        unSelectedColor: Colors.grey[500],
        backgroundColor: Colors.white,
        iconSize: 27,
        selectedColor: Colors.black,
        currentIndex: _currentIndex,
        strokeColor: Colors.white,
        borderRadius: const Radius.circular(15),
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          CustomNavigationBarItem(
            icon: Icon(Icons.near_me_outlined),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.messenger_outline_rounded),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
    );
  }
}










