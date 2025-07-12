import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class Videopage extends StatefulWidget {
  final String channelName;
  final String videoUrl;

  const Videopage({
    super.key,
    required this.channelName,
    required this.videoUrl,
  });

  @override
  State<Videopage> createState() => _VideopageState();
}

class _VideopageState extends State<Videopage> {
  late VideoPlayerController _controller;

  @override
  initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((__) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName, style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),

      body: Center(
        child: _controller.value.isInitialized ? AspectRatio(aspectRatio: _controller.value.aspectRatio, 
        child: VideoPlayer(_controller),
        ) : const CircularProgressIndicator(),
        
        
      ),
    );
  }
}
