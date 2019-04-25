import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerScreen extends StatefulWidget {
  String url;
  VideoPlayerScreen({this.url});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      widget.url,
    );

    // Initialize the controller and store the Future for later use
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure you dispose the VideoPlayerController to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a FutureBuilder to display a loading spinner while you wait for the
      // VideoPlayerController to finish initializing.
      body: GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
             // _controller.setLooping(true);
            });
          },
          child: Center(
            child: Container(
                child: Stack(
                  alignment: FractionalOffset(0.5, 0.5),
                  children: <Widget>[
                    FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the VideoPlayerController has finished initialization, use
                          // the data it provides to limit the Aspect Ratio of the Video
                          return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            // Use the VideoPlayer widget to display the video
                            child: VideoPlayer(_controller),
                          );
                        } else {
                          // If the VideoPlayerController is still initializing, show a
                          // loading spinner
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.done){
                            return Center(
                              child: _controller.value.isPlaying
                                  ? Icon(
                                Icons.pause_circle_outline,
                                size: 60,
                                color: Colors.grey,
                              )
                                  : Icon(
                                Icons.play_circle_outline,
                                size: 60,
                                color: Colors.grey,
                              ),
                            );
                          }else{
                            return Container();
                          }
                        })
                  ],
                )),
          ))

      /*FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the Aspect Ratio of the Video
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), */// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}