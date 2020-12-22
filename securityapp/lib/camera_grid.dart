import 'package:flutter/material.dart';
import 'constFile/ConstFile.dart';

class CameraGridView extends StatefulWidget {
  @override
  _CameraGridViewState createState() => _CameraGridViewState();
}

class _CameraGridViewState extends State<CameraGridView> {
  // VlcPlayerController controller;
  String urlToStream =
      "http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4";
  String urlToStream1 =
      "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4";
  String ipCameraStream1 = "rtsp://192.168.1.109:554/11";

  // @override
  // void initState() {
  //   controller = VlcPlayerController(onInit: () {
  //     controller.play();
  //   });
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   controller = CameraController(urlToStream, ResolutionPreset.medium);
  //   controller.initialize().then((_) {
  //     if (!mounted)
  //       return;
  //     setState(() {});
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }


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
          child: Column(
            children: [

            ],
          ),
        ));
  }
}
