import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:securityapp/constFile/ConstFile.dart';

class CameraGridView extends StatefulWidget {
  @override
  _CameraGridViewState createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {
  VlcPlayerController controller;
  String urlToStream = "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4";
  @override
  void initState() {
    controller = VlcPlayerController(
      onInit: (){
        controller.play();
      }
    );
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
            SizedBox(
              width: 640,
              height: 360,
              child: VlcPlayer(
                aspectRatio: 16 / 9,
                // put here your rtsp ip camera
                url: urlToStream,
                controller: controller,
                placeholder: Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ));
  }
}
