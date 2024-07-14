import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  final PreloadPageController _pageController = PreloadPageController(initialPage: 0);
  final Map<int, VideoPlayerController> _videoControllers = {};

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
void dispose() {
  _videoControllers.forEach((key, controller) {
    controller.dispose();
  });
  super.dispose();
}
@override
Widget build(BuildContext context) {
  var screenWidthSize = MediaQuery.of(context).size.width;
  var screenHeightSize = MediaQuery.of(context).size.height;
  if(screenHeightSize > 392) {
    screenWidthSize = 392;
  }
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: FutureBuilder<List<VideoModel>>(
          future: _videosFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError) {
              return Center(child: Text("ERROR : ${snapshot.error}"));
            } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Videos Found!"));
            }
            final videos = snapshot.data;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: screenWidthSize,
                    height: screenHeightSize - 59,
                    child: PreloadPageView.builder(
                      controller: _pageController,
                        scrollDirection: Axis.vertical,
                        itemCount: videos!.length,
                        preloadPagesCount: 4,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          final videoController = _videoControllers.putIfAbsent(index, () => VideoPlayerController.networkUrl(Uri.parse(video.dbVideosUrl)));
                          return FutureBuilder(
                              future: videoController.initialize(),
                              builder: (context, videoSnapshot) {
                                if(videoSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if(videoSnapshot.hasError) {
                                  return const Center(child: Text("ERROR Loading video"));
                                } else {
                                  return VisibilityDetector(
                                      key: Key('video_$index'),
                                      onVisibilityChanged: (VisibilityInfo info) {
                                        if(info.visibleFraction > 0.5) {
                                          videoController.play();
                                          videoController.setLooping(true);
                                        } else {
                                          videoController.pause();
                                        }
                                      },
                                      child: SizedBox(
                                        height: screenHeightSize,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              width: screenWidthSize,
                                              height: screenHeightSize,
                                              child: AspectRatio(
                                                aspectRatio: videoController.value.aspectRatio,
                                                child: VideoPlayer(videoController),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                        flex: 8,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                const CircleAvatar(
                                                                  backgroundColor: Colors.red,
                                                                  radius: 20,
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                    video.dbUsername,
                                                                    style: const TextStyle(color: Colors.white)
                                                                )
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                                                              child: Text(
                                                                video.dbVideosContext,
                                                                overflow: TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                style: const TextStyle(color: Colors.white),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                    const Flexible(flex: 1, child: Buttons())
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  );
                                }
                              }
                          );
                        }
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    ),
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