import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomActivity extends StatefulWidget {
  const BottomActivity({super.key});
  @override
  bottomState createState() => bottomState();
}

class bottomState extends State<BottomActivity>{


  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Scaffold(
        body: Text("bottom"),
      ),
    );
  }

}