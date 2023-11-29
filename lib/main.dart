import 'package:extrachildhood/View/Aouth/login.dart';
import 'package:extrachildhood/View/mainActivity.dart';
import 'package:extrachildhood/View/passwordReset.dart';
import 'package:extrachildhood/View/Tabs/homePage.dart';
import 'package:extrachildhood/View/uploadcontent.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExtraChildHood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const LoginPage(),
    );
  }
}
