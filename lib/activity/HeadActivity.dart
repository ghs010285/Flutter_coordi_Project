import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadActivity extends StatefulWidget {
  const HeadActivity({super.key});
  @override
  headState createState() => headState();
}

class headState extends State<HeadActivity>{


  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Scaffold(
        body: Text("head"),
      ),
    );
  }

}