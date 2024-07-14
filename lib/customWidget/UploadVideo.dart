import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';


class UploadVideo extends StatefulWidget{
  const UploadVideo({super.key});

  @override
  uploadVideos createState() => uploadVideos();
}

class uploadVideos extends State<UploadVideo> {
  XFile? _video;
  final TextEditingController videoText = TextEditingController();
  bool _isUploadingState = false;

  Future<void> _pickVideo() async{
    final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      _video = video;
    });
  }

  Future<void> _uploadVideo() async {
    final db = FirebaseFirestore.instance;
    if(_video == null || videoText.text.isEmpty) return;
    Map<String, dynamic>? userName;
    setState(() {
      _isUploadingState = true;
    });

    try{
      String userEmail = FirebaseAuth.instance.currentUser!.email!;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where(userEmail).get();
      if(querySnapshot.docs.isNotEmpty){
        setState(() {
          userName = querySnapshot.docs.first.data() as Map<String, dynamic>;
        });
      }
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String uploadUserName = userName!['username'];
      String storageWithStoreId = const Uuid().v4();
      Reference storageReference = FirebaseStorage.instance.ref().child('Video/${Path.basename(_video!.path)}');


      UploadTask uploadTask = storageReference.putFile(File(_video!.path));
      TaskSnapshot storageSanpshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageSanpshot.ref.getDownloadURL();

      final data = {
        'video_text': videoText.text,
        'userName': uploadUserName,
        'uid': userId,
        'videoUrl': downloadUrl,
        'UploadTime' : FieldValue.serverTimestamp(),
      };
      final commentsData = {
        'comments_userName': null,
        'comments_userProfile': null,
        'comments_text' : null,
        'comments_time' : FieldValue.serverTimestamp()
      };

      DocumentReference uploadVideoFireStore = await FirebaseFirestore.instance.collection("Videos").add(data);
      // await uploadVideoFireStore.collection("comments").add(commentsData);
    } catch (e){
      print('ERROR : Adding documents to "users" collection: $e');
    }

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: _video == null ? const Text("No video selected") :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_video!.path.endsWith('.mp4'))
                  Text('Video selected: ${_video!.path}'),
                if (_video!.path.endsWith('.jpg') || _video!.path.endsWith('.png'))
                  Image.file(File(_video!.path)),
                ElevatedButton(
                  onPressed: _uploadVideo,
                  child: const Text('Upload Media to Firebase Storage'),
                ),
              ],
            ),
          ),
          TextFormField(
            controller: videoText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: const BorderSide(
                      width: 200,
                      color: Colors.grey
                  )
              ),
              focusedBorder: OutlineInputBorder( //텍스트 인풋 위젯 클릭 시 바깥 테두리 설정
                  borderRadius: BorderRadius.circular(0.0), //텍스트 인풋 위젯 클릭 시 라운드 0.0(없음)지정
                  borderSide: const BorderSide( //텍스트 인풋 위젯 클릭 시 내부 테두리 설정
                      width: 0, //가로 0지정
                      color: Colors.grey //색상 회색 지정
                  )
              ),
              hintText: '아이디',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 10000,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: "noto-sans",
                        fontWeight: FontWeight.w400
                    )
                ),
                // onPressed: () => UploadServer(),
                onPressed: (){},
                child: const Text('업로드', )
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        tooltip: 'Pick Video',
        child: const Icon(Icons.video_library),
      ),
    );
  }
}