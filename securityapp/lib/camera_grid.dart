import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:securityapp/constFile/ConstFile.dart';

class CameraGridView extends StatefulWidget {
  @override
  _CameraGridViewState createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {

  // VlcPlayerController _vlcPlayerController = VlcPlayerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "دوربین ها",
          style: TextStyle(fontFamily: mainFontFamily),
        ),
      ),
      body: Column(
        children: [
          // VlcPlayer(
          //   controller: _vlcPlayerController,
          //   placeholder: Center(child: CircularProgressIndicator()),
          //   aspectRatio: 25.5,
          //   url: "http://213.226.254.135:91/mjpg/video.mjpg",
          // )
        ],
      )
    );
  }
}
