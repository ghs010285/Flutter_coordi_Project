// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:rxdart/rxdart.dart';
//
// class ChattingRoomList extends StatefulWidget {
//   const ChattingRoomList({super.key});
//
//   @override
//   ChattingRoom createState() => ChattingRoom();
// }
//
//
//
// class ChattingRoom extends State<ChattingRoomList> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? user;
//   late final String _myUid;
//   @override
//   void initState() {
//     super.initState();
//     user = _auth.currentUser;
//     _myUid = user!.uid;
//     print(_myUid);
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<List<QueryDocumentSnapshot>>(
//         stream: CombineLatestStream.list([
//           FirebaseFirestore.instance
//               .collection('chatting')
//               .where('me', isEqualTo: _myUid)
//               .snapshots()
//               .map((snapshot) => snapshot.docs),
//           FirebaseFirestore.instance
//               .collection('chatting')
//               .where('you', isEqualTo: _myUid)
//               .snapshots()
//               .map((snapshot) => snapshot.docs),
//         ]).map((lists) => lists.expand((list) => list).toList()),
//         builder: (context, chatSnapshot) {
//           if (chatSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final chatRooms = chatSnapshot.data ?? [];
//           // final chatRooms = chatSnapshot.data!
//           // ..sort((a,b) => b['lastTime'].compareTo(a['lastTime']));
//
//           return ListView.builder(
//             itemCount: chatRooms.length,
//             itemBuilder: (context, index) {
//               var chatRoom = chatRooms[index];
//               var chatRoomId = chatRoom.id;
//               var otherUserId = chatRoom['me'] == _myUid ? chatRoom['you'] : chatRoom['me'];
//
//               return StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('chatting')
//                     .doc(chatRoomId)
//                     .collection('chatRoom')
//                     .orderBy('time', descending: true)
//                     .limit(1)
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> messageSnapshot) {
//                   if (messageSnapshot.connectionState == ConnectionState.waiting) {
//                     return const ListTile(
//                       title: Text('불러오는중'),
//                     );
//                   }
//
//                   if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
//                     return const ListTile(
//                       title: Text('이렇게 조용한 날은 처음인가요?'),
//                     );
//                   }
//
//                   var lastMessage = messageSnapshot.data!.docs.first;
//                   var lastMsg = lastMessage['msg'];
//                   var lastTime = lastMessage['time'].toDate();
//                   var lastUserName = lastMessage['userName'];
//                   // var lastSenderUid = lastMessage['uid'];
//
//                   return ListTile(
//                     leading: const CircleAvatar(
//                         backgroundColor: Colors.red
//                     ),
//                     title: Text(lastUserName),
//                     subtitle: Text(lastMsg),
//                     trailing: Text('${lastTime.hour}:${lastTime.minute}'),
//                     onTap: () {
//                       print("DATA : ${chatRoomId}");
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }