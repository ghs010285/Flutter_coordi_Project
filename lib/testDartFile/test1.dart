// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../customWidget/IconData.dart';
//
// class ShopModel {
//   final int price;
//   final String brandName;
//   final String shopTitle;
//   final String thumbnail;
//
//   ShopModel({
//     required this.price,
//     required this.brandName,
//     required this.shopTitle,
//     required this.thumbnail
//   });
//
//   factory ShopModel.fromDocument(DocumentSnapshot doc) {
//     return ShopModel(
//         price: doc['price'],
//         brandName: doc['brand_Name'],
//         shopTitle: doc['title'],
//         thumbnail: doc['thumbnail']
//     );
//   }
// }
//
// class TopActivity extends StatefulWidget {
//   const TopActivity({super.key});
//
//   @override
//   State<TopActivity> createState() => TopState();
// }
//
// class TopState extends State<TopActivity>{
//   late Future<List<ShopModel>> _shopFuture;
//   double paddingVal = 0;
//
//   Future<List<ShopModel>> fetchShop() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('brand').get();
//     return querySnapshot.docs.map((doc) => ShopModel.fromDocument(doc)).toList();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _shopFuture = fetchShop();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           leading: IconButton(icon: Icon(FontelloIcons.angle_left),
//             onPressed: () {
//               Navigator.pop(context);
//             },),
//           actions: const [
//             IconButton(icon: Icon(FontelloIcons.icon_home), onPressed: null),
//             IconButton(icon: Icon(FontelloIcons.bell_white), onPressed: null),
//             IconButton(icon: Icon(FontelloIcons.cart), onPressed: null),
//           ],
//         ),
//         body: Center(
//             child: FutureBuilder<List<ShopModel>> (
//               future: _shopFuture,
//               builder: (context, snapshot) {
//                 if(snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if(!snapshot.hasError) {
//                   return const Center(child: Text("이런! 문제가 발생했어요!"));
//                 } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('서버 문제가 발생했습니다. 다시 시도 해 주세요.'));
//                 }
//                 final shop = snapshot.data;
//                 print('DATA : $shop');
//
//                 return GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 5,
//                       mainAxisSpacing: 10,
//                       mainAxisExtent: 350,
//                     ),
//                     itemCount: shop!.length,
//                     itemBuilder: (context, index) {
//                       return GridTile(
//                         footer: GridTileBar(
//                           backgroundColor: Colors.yellow,
//                           title: const Text('footer'),
//                           subtitle: Text('Item $index'),
//                         ),
//                         child: Container(
//                             color: Colors.pink
//                         ),
//                       );
//                     }
//                 );
//               },
//             )
//         )
//     );
//   }
//
// }
//
