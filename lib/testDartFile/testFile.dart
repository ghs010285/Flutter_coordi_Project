// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class VideoList extends StatefulWidget{
//   const VideoList({super.key});
//
//   @override
//   State<VideoList> createState() => _VideoListState();
// }
//
//
// class _VideoListState extends State<VideoList> {
//   String dbUsername = '';
//   String dbVideosContext = '';
//   FirebaseFirestore db = FirebaseFirestore.instance;
//
//   @override
//   void initState(){
//     super.initState();
//     _getMediaList();
//   }
//
//   // Future<List<Map<String, dynamic>>?> _getMediaList() async {
//   //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Videos").get();
//   //   try {
//   //     List<Map<String, dynamic>> videoDataList = querySnapshot.docs.map((DocumentSnapshot document) {
//   //       Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//   //       String videoUrl = data['videoUrl'] as String;
//   //       dbUsername = data['userName'] as String;
//   //       dbVideosContext = data['video_text'] as String;
//   //       return {
//   //         'videoUrl': videoUrl,
//   //         'userName': dbUsername,
//   //         'videoText': dbVideosContext,
//   //       };
//   //     }).where((videoData) => videoData != null).toList();
//   //     return videoDataList;
//   //   } catch (e) {
//   //   }
//   // }
//
//   Future<List<String>?> _getMediaList() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Videos").get();
//     try{
//       List<String> urls = querySnapshot.docs.map((DocumentSnapshot document) {
//         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//         String videoUrl = data['videoUrl'] as String;
//         dbUsername = data['userName'] as String;
//         dbVideosContext = data['video_text'] as String;
//         return videoUrl;
//       })
//           .where((urls) => urls != null).toList();
//       return urls;
//     } catch (e) {
//
//     }
//
//   }
//
//   @override
//   void dispose(){
//     super.dispose();
//   }
//
//   @override
//
//
//   @override
//   Widget build(BuildContext context) {
//     var screenWidthSize = MediaQuery.of(context).size.width;
//     var screenHeightSize = MediaQuery.of(context).size.height - 59;
//     if(screenWidthSize > 392){
//       screenWidthSize = 392;
//     }
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FutureBuilder(
//                   future: _getMediaList(),
//                   builder: (context, snapshot) {
//                     if(snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if(snapshot.hasError){
//                       return Center(child: Text("Error: $snapshot.error"));
//                     } else {
//                       List<String> urls = snapshot.data as List<String>;
//                       // List<Map<String, dynamic>> urls = snapshot.data ?? [];
//                       print(" DATA :  ${urls}");
//
//                       return Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Center(
//                               child: SizedBox(
//                                 width: screenWidthSize,
//                                 height: MediaQuery.of(context).size.height-60,
//                                 child: PageView.builder(
//                                     scrollDirection: Axis.vertical,
//                                     itemCount: urls.length,
//                                     itemBuilder: (_, index) {
//                                       return Container(
//                                         height: screenHeightSize,
//                                         child:  Stack(
//                                           children: [
//                                             SizedBox(
//                                               width: screenWidthSize,
//                                               height: screenHeightSize,
//                                               child: VideoView(videoUri: urls[index]),
//                                             ),
//                                             const Align(
//                                               alignment: Alignment.bottomLeft,
//                                               child: Padding(
//                                                 padding: EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Flexible(
//                                                         flex: 8,
//                                                         child: Column(
//                                                           mainAxisSize: MainAxisSize.min,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             Row(
//                                                               mainAxisSize: MainAxisSize.min,
//                                                               children: [
//                                                                 CircleAvatar(
//                                                                   backgroundColor: Colors.red,
//                                                                   radius: 20,
//                                                                 ),
//                                                                 SizedBox(
//                                                                   width: 20,
//                                                                 ),
//                                                                 Text(
//                                                                   "",
//                                                                   style: TextStyle(color: Colors.white),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                             Padding(
//                                                               padding: EdgeInsets.only(top: 10, left: 5, right: 5),
//                                                               child: Text(
//                                                                 "qweqweqweqweqweqweqweqweqweqweqweQWEASXadqwe34w4tergdfg3t5566rrfhfdfwe234wdscxcnvb,jlopi80879686785yrgfdghghkn./l;'o]opuyuiutweqasczf",
//                                                                 overflow: TextOverflow.ellipsis,
//                                                                 softWrap: true,
//                                                                 maxLines: 2,
//                                                                 style: TextStyle(color: Colors.white),
//                                                               ),
//                                                             )
//
//                                                           ],
//                                                         )
//                                                     ),
//                                                     const Flexible(flex: 1, child: Buttons())
//                                                   ],
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       );
//                                     }
//                                 ),
//                               ),
//                             )
//                           ]
//                       );
//                     }
//                   }
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Buttons extends StatelessWidget{
//   const Buttons({super.key});
//
//   @override
//   Widget build(BuildContext context){
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//
//         IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.heart_broken,
//               color: Colors.white,
//             )
//         ),
//         IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.comment,
//               color: Colors.white,
//             )
//         ),
//         IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.share,
//               color: Colors.white,
//             )
//         ),
//       ],
//     );
//   }
// }


// 실시간 데이터 가져오기
// FirebaseFirestore.instance.collection('Videos').snapshots().listen(
// (snapshot) {
// for (var document in snapshot.docs){
// Map<String, dynamic> data = document.data() as Map<String, dynamic>;
// print("Document ID : ${document.id}");
// data.forEach((key, value) {
// print("$key: $value");
// });
// print('---');
// }
// });



// QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Videos").get();
//
// try{
// List<String> urls = querySnapshot.docs.map((DocumentSnapshot document) {
// Map<String, dynamic> data = document.data() as Map<String, dynamic>;
// String videoUrl = data['videoUrl'] as String;
// dbUsername = data['userName'] as String;
// dbVideosContext = data['video_text'] as String;
// return videoUrl;
// })
//     .where((urls) => urls != null).toList();
// print("DATA URLS : ${urls}");
// return urls;
// } catch (e) {
//
// }

// Future<List<String>?> _getMediaList() async {
//   List<String> urls =[];
//   FirebaseFirestore.instance.collection("Videos").get().then(
//         (querySnapshot) {
//       for(var docSnapshot in querySnapshot.docs) {
//         var data = docSnapshot.data();
//         dbVideosContext = data["video_text"];
//         urls = data["videoUrl"];
//         var uploadTime = data["UploadTime"];
//         dbUsername = data["userName"];
//       }
//       return urls;
//     },
//     onError: (e) => print("Error completing: $e"),
//   );
// }