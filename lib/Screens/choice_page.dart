import 'package:flutter/material.dart';
import 'package:technova/Screens/req_homescreen.dart';
import 'package:velocity_x/velocity_x.dart';

class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
              color: Vx.red500,
              child: TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));}, child: "Request".text.xl5.color(Vx.white).make()),
            ),
          ),
          Expanded(
            child: Container(width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
              color: Vx.green500,
              child: TextButton(onPressed: (){}, child: "Respond".text.xl5.color(Vx.white).make())
            ),
          ),
        ],
      ),
    ));
  }
}