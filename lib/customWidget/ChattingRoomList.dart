import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChattingRoomList extends StatefulWidget {
  const ChattingRoomList({super.key});

  @override
  ChattingRoom createState() => ChattingRoom();
}



class ChattingRoom extends State<ChattingRoomList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  late final String _myUid;
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _myUid = user!.uid;
    print(_myUid);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: CombineLatestStream.list([
          FirebaseFirestore.instance
              .collection('chatting')
              .where('me', isEqualTo: _myUid)
              .snapshots()
              .map((snapshot) => snapshot.docs),
          FirebaseFirestore.instance
              .collection('chatting')
              .where('you', isEqualTo: _myUid)
              .snapshots()
              .map((snapshot) => snapshot.docs),
        ]).map((lists) => lists.expand((list) => list).toList()),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!chatSnapshot.hasData || chatSnapshot.data!.isEmpty) {
            return const Center(child: Text('No chat rooms available.'));
          }
          final chatRooms = chatSnapshot.data ?? [];

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchLastMessages(chatRooms),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No messages available.'));
              }
              final sortedChatRooms = snapshot.data!
                ..sort((a, b) => b['lastTime'].compareTo(a['lastTime']));

              return ListView.builder(
                itemCount: sortedChatRooms.length,
                itemBuilder: (context, index) {
                  var chatRoom = sortedChatRooms[index];
                  var lastMsg = chatRoom['lastMsg'];
                  var lastTime = chatRoom['lastTime'];
                  var userName = chatRoom['userName'];
                  var chatRoomsId = chatRoom['RoomsId'];

                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.red,
                    ),
                    title: Text(userName),
                    subtitle: Text(lastMsg),
                    trailing: Text('${lastTime.hour}:${lastTime.minute}'),
                    onTap: () {
                      print("DATA : ${chatRoomsId}");
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchLastMessages(
      List<QueryDocumentSnapshot> chatRooms) async {
    List<Map<String, dynamic>> lastMessages = [];

    for (var chatRoom in chatRooms) {
      var chatRoomId = chatRoom.id;
      var otherUserId = chatRoom['me'] == _myUid
          ? chatRoom['you']
          : chatRoom['me'];

      var messageSnapshot = await FirebaseFirestore.instance
          .collection('chatting')
          .doc(chatRoomId)
          .collection('chatRoom')
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (messageSnapshot.docs.isNotEmpty) {
        var lastMessage = messageSnapshot.docs.first;
        var lastMsg = lastMessage['msg'];
        var lastTime = lastMessage['time'].toDate();
        var userName = lastMessage['userName'];
        var chatRoomsId = chatRoomId;

        lastMessages.add({
          'chatRoomId': chatRoomId,
          'otherUserId': otherUserId,
          'lastMsg': lastMsg,
          'lastTime': lastTime,
          'userName': userName,
          'chatRoomsId': chatRoomsId,
        });
      }
    }

    return lastMessages;
  }
}