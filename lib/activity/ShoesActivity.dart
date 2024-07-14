import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoesActivity extends StatefulWidget {
  const ShoesActivity({super.key});
  @override
  shoesState createState() => shoesState();
}

class shoesState extends State<ShoesActivity>{


  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Scaffold(
        body: Text("Shoes"),
      ),
    );
  }

}