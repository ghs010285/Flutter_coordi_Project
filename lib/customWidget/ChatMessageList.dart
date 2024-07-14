// import 'package:cloud_firestore/cloud_firestore.dart';
//
// // 사용자 정보 클래스
// class User {
//   final String uid; // 고유 식별자
//   final String name; // 이름
//   final DateTime createdAt; // 계정 생성일
//   final bool isSuspended; // 계정 정지 여부
//   final bool isAdmin; // 관리자 여부
//   final String profileImageUrl; // 사용자 프로필 이미지 URL
//
//   User({
//     this.uid,
//     this.name,
//     this.createdAt,
//     this.isSuspended,
//     this.isAdmin,
//     this.profileImageUrl,
//   });
//
//   // Firestore 문서에서 User 객체로 변환하는 팩토리 생성자
//   factory User.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data();
//     return User(
//       uid: doc.id,
//       name: data['name'] ?? '', // 이름 필드 가져오기
//       createdAt: (data['createdAt'] as Timestamp)!.toDate(), // 생성일 필드 가져오기
//       isSuspended: data['isSuspended'] ?? false, // 정지 여부 필드 가져오기
//       isAdmin: data['isAdmin'] ?? false, // 관리자 여부 필드 가져오기
//       profileImageUrl: data['profileImageUrl'] ?? '', // 프로필 이미지 URL 필드 가져오기
//     );
//   }
// }
//
// // 채팅 메시지 클래스
// class ChatMessage {
//   final String messageId; // 메시지 고유 식별자
//   final String senderUid; // 메시지를 보낸 사용자 UID
//   final String messageText; // 메시지 텍스트
//   final DateTime timestamp; // 메시지 보낸 시간
//
//   ChatMessage({
//     this.messageId,
//     this.senderUid,
//     this.messageText,
//     this.timestamp,
//   });
//
//   // Firestore 문서에서 ChatMessage 객체로 변환하는 팩토리 생성자
//   factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data();
//     return ChatMessage(
//       messageId: doc.id, // 메시지 ID 가져오기
//       senderUid: data['senderUid'] ?? '', // 보낸 사용자 UID 가져오기
//       messageText: data['messageText'] ?? '', // 메시지 텍스트 가져오기
//       timestamp: (data['timestamp'] as Timestamp)?.toDate(), // 시간 정보 가져오기
//     );
//   }
// }
//
// // Firestore 서비스
// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // 사용자 정보 가져와야함
//   Future<User> getUser(String uid) async {
//     if (uid == null) {
//       throw ArgumentError('UID cannot be null'); // null일 경우 에러가 생겨야할듯???
//     }
//     DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
//     return userDoc.exists ? User.fromFirestore(userDoc) : null; // 존재 => User 객체 반환, 없으면 null
//   }
//
//   // 채팅 메시지 목록 데려와야함
//   Stream<List<ChatMessage>> getChatMessages(String chatRoomId) {
//     return _db
//         .collection('chatRooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => ChatMessage.fromFirestore(doc))
//         .toList());
//   }
//
//   // 새로운 채팅 메시지 보내기
//   Future<void> sendMessage(String chatRoomId, String senderUid, String messageText) async {
//     await _db.collection('chatRooms').doc(chatRoomId).collection('messages').add({
//       'senderUid': senderUid, // 보낸 사용자 UID 저장
//       'messageText': messageText, // 메시지 텍스트 저장해야함
//       'timestamp': FieldValue.serverTimestamp(), // 서버 시간 기록하는부분
//     });
//   }
// }
