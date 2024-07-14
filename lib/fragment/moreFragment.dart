import 'package:flutter/material.dart';
import 'package:web_shopping/customWidget/ChattingRoomList.dart';

class moreFragment extends StatefulWidget{
  const moreFragment({super.key});

  @override
  moreShow createState() => moreShow();
}

class moreShow extends State<moreFragment> {
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: ChattingRoomList()
    );
  }
}