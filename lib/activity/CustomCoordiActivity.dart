import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCoordiActivity extends StatefulWidget {
  const CustomCoordiActivity({super.key});
  @override
  customCoordiState createState() => customCoordiState();
}

class customCoordiState extends State<CustomCoordiActivity>{


  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Scaffold(
        body: Text("CustomCoordi"),
      ),
    );
  }

}