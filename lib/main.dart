import 'package:flutter/material.dart';
import 'package:technova/Screens/chatpage(removed).dart';
import 'package:technova/Screens/choice_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: 
      ChatPage(
        recieverUserName: 'ChatBot', // Provide a username
        recieverID: 'user123',        // Provide a receiver ID
        recieverEmail: 'john@example.com', // Provide an email
      ),
    );
  }
}
