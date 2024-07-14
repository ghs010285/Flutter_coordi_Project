import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../customWidget/IconData.dart';

class ShopModel {
  final int price;
  final String brandName;
  final String shopTitle;
  final String thumbnail;

  ShopModel({
    required this.price,
    required this.brandName,
    required this.shopTitle,
    required this.thumbnail
});

  factory ShopModel.fromDocument(DocumentSnapshot doc) {
    return ShopModel(
        price: doc['price'],
        brandName: doc['brand_Name'],
        shopTitle: doc['title'],
        thumbnail: doc['thumbnail']
    );
  }
}

class TopActivity extends StatefulWidget {
  const TopActivity({super.key});
  
  @override
  TopState createState() => TopState();
}

class TopState extends State<TopActivity>{
  // late Future<List<ShopModel>> _shopFuture;
  double paddingVal = 0;
  
  // Future<List<ShopModel>> fetchShop() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('brand').get();
  //   return querySnapshot.docs.map((doc) => ShopModel.fromDocument(doc)).toList();
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _shopFuture = fetchShop();
  // }
  
  
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(FontelloIcons.angle_left),
            onPressed: () {
          Navigator.pop(context);
        },),
        actions: const [
          IconButton(icon: Icon(FontelloIcons.icon_home), onPressed: null),
          IconButton(icon: Icon(FontelloIcons.bell_white), onPressed: null),
          IconButton(icon: Icon(FontelloIcons.cart), onPressed: null),
        ],
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>> (
        stream: CombineLatestStream.list([
          FirebaseFirestore.instance.collection('brand').snapshots().map((snapshot) => snapshot.docs)
        ]).map((lists) => lists.expand((list) => list).toList()),
        builder: (context, shopSnapshot) {
          if (shopSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(!shopSnapshot.hasError) {
            return const Center(child: Text("이런! 문제가 발생했어요!"));
          } else if(!shopSnapshot.hasData || shopSnapshot.data!.isEmpty) {
            return const Center(child: Text('서버 문제가 발생했습니다. 다시 시도 해 주세요.'));
          }
          final shop = shopSnapshot.data ?? [];

          return FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if(!snapshot.hasError) {
                  return const Center(child: Text("이런! 문제가 발생했어요!"));
                } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('서버 문제가 발생했습니다. 다시 시도 해 주세요.'));
                }
              }
          );
        }
      )
    );
  }
}

