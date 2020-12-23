import 'package:flutter/material.dart';
import 'constFile/ConstFile.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'constFile/texts.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class CameraGridView extends StatefulWidget {
  @override
  _CameraGridViewState createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {
  String urlToStream =
      "http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4";
  String urlToStream1 =
      "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4";
  String ipCameraStream1 = "rtsp://192.168.1.109:554/11";

  // VlcPlayerController controller;
  //
  // @override
  // void initState() {
  //   controller = VlcPlayerController(onInit: () {
  //     controller.play();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            camerasTitle,
            style: TextStyle(fontFamily: mainFontFamily),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // VlcPlayer(
              //   controller: controller,
              //   aspectRatio: 4 / 3,
              //   url: urlToStream1,
              // ),
              Mjpeg(
                width: double.infinity,
                height: 250,
                isLive: true,
                stream: urlToStream1,
              )
            ],
          ),
        ));
  }
}
