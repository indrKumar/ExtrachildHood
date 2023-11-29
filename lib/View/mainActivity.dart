import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/View/Tabs/homePage.dart';
import 'package:extrachildhood/View/Tabs/profile.dart';
import 'package:extrachildhood/View/Tabs/social_media_content.dart';
import 'package:extrachildhood/View/Tabs/task_tab.dart';
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
    var  tabs = [
     const TaskTab(),
      const HomePage(),
      const SocialMedeaContent(),
      const ProfilePage(),
    ];
    return  Scaffold(
      body: tabs[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 30),
        selectedLabelStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
        selectedItemColor: Helper.primaryColor,
          showUnselectedLabels: true,
        currentIndex: _currentindex,
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
          items: const [
        BottomNavigationBarItem(icon:Icon(Icons.task_outlined),label: 'Pending Task', ),
            BottomNavigationBarItem(icon:Icon(Icons.task),label: 'Completed Task', ),
            BottomNavigationBarItem(icon:Icon(Icons.cameraswitch_rounded),label: 'Social media' ),
        BottomNavigationBarItem(icon:Icon(Icons.person_outline_outlined),label: 'Profile', ),
      ]),


    );
  }
}
