import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_shopping/fragment/mainFragment.dart';
import 'package:web_shopping/fragment/mediaFragment.dart';
import 'package:web_shopping/fragment/moreFragment.dart';




class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.user});

  final User user;


  @override
  mainPageState createState() => mainPageState();
}


class mainPageState extends State<MainPage> {

  // body: Text(user.email.toString()),
  var _fragmentIndex = 1;
  final List _fragment = [
    const mainFragment(),
    const mediaFragment(),
    const moreFragment(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _fragment[
        _fragmentIndex
      ],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _fragmentIndex,
        onTap: (value) {
          setState(() {
            _fragmentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Main', activeIcon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.shower_outlined), label: 'shower', activeIcon: Icon(Icons.shower)),
          BottomNavigationBarItem(icon: Icon(Icons.more_outlined), label: 'more', activeIcon: Icon(Icons.more)),
        ],
      ),
    );
  }
}