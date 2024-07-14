import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_shopping/activity/AccessoryActivity.dart';
import 'package:web_shopping/activity/BottomActivity.dart';
import 'package:web_shopping/activity/CustomCoordiActivity.dart';
import 'package:web_shopping/activity/HeadActivity.dart';
import 'package:web_shopping/activity/ShoesActivity.dart';
import 'package:web_shopping/activity/TopActivity.dart';
import 'package:web_shopping/customWidget/IconData.dart';


class mainFragment extends StatefulWidget{
  const mainFragment({super.key});

  @override
  mainShow createState() => mainShow();
}

class mainShow extends State<mainFragment> {
  List<String> imgUrl = [];
  List<String> notice_text = [];
  final PageController _pageController = PageController();
  final PageController _notice_pageController = PageController();
  Timer ? _adsTimer, _noticeTimer;
  double paddingVal = 10.0;

  @override
  void initState() {
    super.initState();
    _AdsNotice();
    _NoticeText();
    _adsTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if(_pageController.hasClients && imgUrl.isNotEmpty) {
        int nextPage = (_pageController.page!.toInt() +1) % imgUrl.length;
        _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,);
      }
    });
    _noticeTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if(_notice_pageController.hasClients && notice_text.isNotEmpty) {
        int nextPage = (_notice_pageController.page!.toInt() +1) % notice_text.length;
        _notice_pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,);
      }
    });
    // _getWeather();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _adsTimer?.cancel();
    _noticeTimer?.cancel();
    super.dispose();
  }

  void _AdsNotice() {
    FirebaseFirestore.instance.collection('Ads').snapshots().listen((snapshot) {
      List<String> newImgUrl = [];
      for (var doc in snapshot.docs) {
        newImgUrl.add(doc['imgUrl']);
      }
      setState(() {
        imgUrl = newImgUrl;
      });
    });
  }

  void _NoticeText() {
    FirebaseFirestore.instance.collection('notice')
        .snapshots().listen((snapshot) {
          List<String> newNoticeText = [];
          for (var doc in snapshot.docs) {
            newNoticeText.add(doc['notice_title']);
          }
          setState(() {
            notice_text = newNoticeText;
          });
    });
  }

  @override
  Widget build(BuildContext context){
    var screenWidthSize = MediaQuery.of(context).size.width;
    if(screenWidthSize > 392) {
      screenWidthSize = 392;
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const IconButton(icon: Icon(Icons.menu), onPressed: null),
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                    hintText: '검색을 해 주세요.',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            width: 200,
                            color: Colors.grey
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            width: 0,
                            color: Colors.black
                        )
                    ),
                    suffixIcon: const Icon(FontelloIcons.search)
                ),
              ),
            ),
          ),
          actions: const [
            IconButton(icon: Icon(FontelloIcons.cart), onPressed: null),
            IconButton(icon: Icon(FontelloIcons.bell_white), onPressed: null)
          ],
        ),
        body:  Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(right: 15),
                    child: Icon(FontelloIcons.icon_bullhorn),
                  ),
                  Flexible(

                    child: SizedBox(
                      width: screenWidthSize,
                      height: 30,
                      child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _notice_pageController,
                          itemCount: notice_text.length,
                          itemBuilder: (context, index) {
                            return Text(
                              notice_text[index],
                              style: TextStyle(

                              ),
                            );
                          }
                      ),
                    )
                  ),
                ],
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 120,
              child: PageView.builder(
                controller: _pageController,
                itemCount: imgUrl.length,
                itemBuilder: (context, index) {
                  return Image.network(imgUrl[index]);
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.blue,
              child: const Text("날씨영역입니다~"),
            ),
            const Text("옷을 쒸발 ㅈㄴ 쌈@뽕하게;;"),

            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(paddingVal),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 105,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1
                                    )
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => const TopActivity()
                                      )
                                    );
                                  },
                                ),
                              ),
                               const SizedBox(
                                  width: 200,
                                  child: Text("상의", textAlign: TextAlign.center,),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(paddingVal),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 105,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1
                                    )
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => const BottomActivity()
                                        )
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                child: Text("하의", textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(paddingVal),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 105,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1
                                    )
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => const HeadActivity()
                                        )
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                child: Text("모자", textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(paddingVal),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 105,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1
                                    )
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => const ShoesActivity()
                                        )
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                child: Text("신발", textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(paddingVal),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 105,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1
                                    )
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => const CustomCoordiActivity()
                                        )
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                child: Text("커스텀코디", textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(paddingVal),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 105,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1
                                    )
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => const AccessoryActivity()
                                        )
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 200,
                                child: Text("악세서리", textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Text("copyright R Veno Studio | 2024")
                //   ],
                // )
              ],
            )




          ],
        )
      ),
    );
  }
}