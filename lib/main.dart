import 'package:flutter/material.dart';
import 'package:technova/Screens/choice_page.dart';
import 'package:technova/Screens/req_homescreen.dart';
import 'package:technova/Screens/resp_homescreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      //initialRoute: ,
      routes: {},
    );
  }
}
