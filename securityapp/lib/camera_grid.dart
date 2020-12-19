import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:securityapp/constFile/ConstFile.dart';

class CameraGridView extends StatefulWidget {
  @override
  _CameraGridViewState createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {
  VlcPlayerController controller;
  String urlToStream = "http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4";
  String urlToStream1 = "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4";
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: VlcPlayer(
                    aspectRatio: 16 / 9,
                    // put here your rtsp ip camera
                    url: urlToStream,
                    controller: controller,
                    placeholder: Center(child: CircularProgressIndicator()),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: VlcPlayer(
                    autoplay: true,
                    aspectRatio: 16 / 9,
                    // put here your rtsp ip camera
                    url: urlToStream1,
                    controller: controller,
                    placeholder: Center(child: CircularProgressIndicator()),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
