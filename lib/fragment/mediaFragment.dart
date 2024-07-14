import 'package:flutter/material.dart';
import 'package:web_shopping/customWidget/VideoList.dart';

class mediaFragment extends StatelessWidget{
  const mediaFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoList(),
    );
  }
}