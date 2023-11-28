import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/View/homePage.dart';
import 'package:extrachildhood/View/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainActivityPage extends StatefulWidget {
  const MainActivityPage({super.key});

  @override
  State<MainActivityPage> createState() => _MainActivityPageState();
}

class _MainActivityPageState extends State<MainActivityPage> {
  var _currentindex = 0;

  @override
  Widget build(BuildContext context) {
    var _tabs = [
      HomePage(),
      ProfilePage()
    ];
    return  Scaffold(
      body: _tabs[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(size: 30),
        selectedLabelStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
        selectedItemColor: Helper.primaryColor,
          showUnselectedLabels: true,
        currentIndex: _currentindex,
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
          items: [
        BottomNavigationBarItem(icon:Icon(Icons.home),label: 'Home', ),
        BottomNavigationBarItem(icon:Icon(Icons.person_outline_outlined),label: 'Profile', ),
      ]),


    );
  }
}
