import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccessoryActivity extends StatefulWidget {
  const AccessoryActivity({super.key});
  @override
  accessoryState createState() => accessoryState();
}

class accessoryState extends State<AccessoryActivity>{


  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Scaffold(
        body: Text("Accessory"),
      ),
    );
  }

}