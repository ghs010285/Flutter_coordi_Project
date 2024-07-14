import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoModel {
  final String dbUsername;
  final String dbVideosContext;
  final String dbVideosUrl;

  VideoModel({
    required this.dbUsername,
    required this.dbVideosContext,
    required this.dbVideosUrl,
  });

  factory VideoModel.fromDocument(DocumentSnapshot doc) {
    return VideoModel(
      dbUsername: doc['userName'],
      dbVideosContext: doc['video_text'],
      dbVideosUrl: doc['videoUrl'],
    );
  }
}

class VideoList extends StatefulWidget{
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}


class _VideoListState extends State<VideoList> {
  late Future<List<VideoModel>> _videosFuture;

  Future<List<VideoModel>> fetchVideos() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Videos").get();
    return querySnapshot.docs.map((doc) => VideoModel.fromDocument(doc)).toList();
  }
  @override
  void initState() {
    super.initState();
    _videosFuture = fetchVideos();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.pink,
          child: FutureBuilder<List<VideoModel>>(
              future: _videosFuture,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if(snapshot.hasError) {
                  return Center(child: Text('ERROR : ${snapshot.error}'));
                } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Videos Found'));
                }
                final videos = snapshot.data!;

                return Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 5000,
                  child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        final videoController = VideoPlayerController.networkUrl(Uri.parse(video.dbVideosUrl));
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: FutureBuilder(
                              future: videoController.initialize(),
                              builder: (context, videoSnapshot) {
                                if(videoSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if(videoSnapshot.hasError) {
                                  return const Center(child: Text('Error loading video'));
                                }
                                return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 0,
                                    child: Container(
                                        color: Colors.blue,
                                        child: Column(
                                          children: [
                                            AspectRatio(
                                              aspectRatio: videoController.value.aspectRatio,
                                              child: VideoPlayer(videoController),
                                            ),
                                            // Text(
                                            //   'User: ${video.dbUsername}',
                                            //   style: const TextStyle(
                                            //       fontSize: 16
                                            //   ),
                                            // ),
                                            // const SizedBox(height: 8),
                                            // Text(
                                            //   'Description: ${video.dbVideosContext}',
                                            //   style: const TextStyle(
                                            //     fontSize: 16,
                                            //   ),
                                            // ),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  videoController.value.isPlaying ? videoController.pause() : videoController.play();
                                                });
                                              },
                                              child: Icon(videoController.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                            )
                                          ],
                                        )
                                    )
                                );
                              }
                          ),
                        );
                      }
                  ),
                );
              }
          ),
        )
    );
  }
}

class Buttons extends StatelessWidget{
  const Buttons({super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.heart_broken,
              color: Colors.white,
            )
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.comment,
              color: Colors.white,
            )
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            )
        ),
      ],
    );
  }
}