import 'package:flutter/material.dart';
import 'package:technova/Screens/navBarPage.dart';
import 'package:technova/utils/theme.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.darktheme(context),
      debugShowCheckedModeBanner: false,
       home:BottomNavigationBarPage()
    );
  }
}
